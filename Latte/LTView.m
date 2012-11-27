//
//  LTView.m
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "LTPrefixes.h"

@interface LTView ()

/* The node that define the structure of the view */
@property (strong) LTNode *node;

/* The bound object */
@property (strong) id object;
@property (strong) LTContext *context;
@property (strong) LTLocale *locale;

/* Bindings with all the object and context properties.
 * They contains LTTarget objects. */
@property (strong) NSMutableArray *bindings;
@property (strong) NSMutableArray *contextBindings;

/*View dictonary for the visual constraints*/
@property (strong) NSMutableDictionary *viewsDictionary;

@end

@implementation LTView

#pragma mark -
#pragma mark constructors

/* Constructs a new latte view.
 * If the debug flag is enabled, the view is registered in 
 * the watch file service.
 * The filename parameter points to the markup file with the 
 * view definition. (markup file's parse structure are cached) 
 */
- (id)initWithLatteFile:(NSString*)filename
{
    if (self = [super init]) {
        
        //parses and initializes the current view
        [self loadViewFromLatteFile:filename];
        self.locale = [LTLocale sharedInstance];
                    
#ifdef DEBUG
        [[LTWatchFileServer sharedInstance] registerView:self];
#endif
    }
    
    return self;
}

/* Constructs a new latte view.
 * The viewDidLoad block is called after the view initialization
 * and can be used to setup some components.
 * Rember that you can access to any view's subviews by using the 
 * selection method $(@"#id") */
- (id)initWithLatteFile:(NSString*)filename
            viewDidLoad:(void (^)(LTView *view))viewDidLoadBlock
{
    if (self = [self initWithLatteFile:filename])
        viewDidLoadBlock(self);
    
    return self;
}


/* deregister the view */
- (void)dealloc
{
#ifdef DEBUG
    [[LTWatchFileServer sharedInstance] deregisterView:self];
#endif
}


#pragma mark -
#pragma mark properties

/* Bind the given object to this view.
 * See the guide for more information about it. */
- (void)bind:(id)object
{
    _object = object;
    _context = [[LTContext alloc] init];
    
    [self refreshView];
}

- (void)bind:(id)object withContext:(void (^)(LTContext *context, id object))contextSetup
{
    _object = object;
    
    LTContext *context = _context = [[LTContext alloc] init];
    contextSetup(context, object);

    [self refreshView];
}

#pragma mark -
#pragma mark view initializer

NSArray *LTRenderViewsFromNodeChildren(LTNode *node, NSMutableArray **bindings, NSMutableArray **contextBindings, NSMutableDictionary *viewsDictionary)
{
    
#define ERR(fmt, ...) {NSLog((fmt), ##__VA_ARGS__); goto render_err;}
    
    //the rendered views
    NSMutableArray *views = [[NSMutableArray alloc] init];

    //recoursively creates all the views associated 
    //to the nodes in the parse tree
    for (LTNode *n in node.children) {
        
        UIView *object = [[NSClassFromString(n.data[kLTTagIsa]) alloc] init];

        if (!object) 
            ERR(@"Class %@ not found", n.data[kLTTagIsa]);
		
		//view dictionary to handle visual format languange constraints
		if (viewsDictionary && n.data[kLTTagId]) {
			
			NSString *viewId = n.data[kLTTagId];
		
			//the visual layout language is not compatible
			//with the # prefix
			if ([viewId hasPrefix:@"#"])
				viewId = [viewId substringFromIndex:1];
			
			viewsDictionary[viewId] = object;
		}

        @try {
            LTStaticInitializeViewFromNodeDictionary(object, n.data, bindings, contextBindings);
        
        } @catch (NSException *exception) {
            ERR(@"Unable to initialize the view with the node's data: %@", n.data);
        }

        //recoursively creates and add the subviews
        for (UIView *subview in LTRenderViewsFromNodeChildren(n, bindings, contextBindings, viewsDictionary))
            [object addSubview:subview];
		
		[views addObject:object];
    }
    
    return views;
    
render_err:
    NSLog(@"Rendering error");
    return nil;
}

NSString *LTRenderStringFromTemplate(LTKVOTemplate *template,  LTView *object)
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (NSString *keypath in template.keypaths)
        [values addObject:[object valueForKeyPath:keypath]];

    return [NSString stringWithFormat:template.template array:values];
}

#pragma mark -
#pragma mark view init

/* Recreates the entire view hierarchy from the markup 
 * file passed as argument. */
- (void)loadViewFromLatteFile:(NSString*)filename
{
    self.filename = filename;
    
    self.bindings = [[NSMutableArray alloc] init];
    self.contextBindings = [[NSMutableArray alloc] init];
    
    self.node = [[LTParser sharedInstance] parseFile:filename];
    [self renderView];
    
    //refresh the object
    [self refreshView];
}

/* It creates and layouts all the subviews by inspecting the node 
 * tree structure. Object and context bindings are also fetched  and cached in this stage of 
 * initialization. */
- (void)renderView
{
    //create the bindings map
    NSMutableArray *map = [[NSMutableArray alloc] init], *contextMap = [[NSMutableArray alloc] init];
    self.viewsDictionary = [[NSMutableDictionary alloc] init];
	
    //render the static components of the view
    NSArray *subviews = LTRenderViewsFromNodeChildren(self.node, &map, &contextMap, self.viewsDictionary);
    
    self.bindings = map;
    self.contextBindings = contextMap;
    
    //remove all the previous subviews
    for (UIView *subview in self.subviews) 
        [subview removeFromSuperview];
    
    if (subviews.count)
        for (UIView *subview in subviews)
            [self addSubview:subview];
	
	//costraints
	#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
	[self initializeConstraints];
	#endif
}

/* Creates the autolayout constraints, constructing them from the markup file */
- (void)initializeConstraints
{
	//no constraints defined for this view
	if (!self.node.constraints) return;
	
	for (NSDictionary *c in self.node.constraints) {
		NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:c[@"format"]
																	   options:LTLayoutFormatOptionsFromArray(c[@"options"])
																	   metrics:c[@"metrics"]
																		 views:self.viewsDictionary];
		[self addConstraints:constraints];
	}
}

/* Transform an array of option into the NSLayoutFormatOptions integer flag */
NSLayoutFormatOptions LTLayoutFormatOptionsFromArray(NSArray *array)
{
	if (!array) return 0;
	
	NSLayoutFormatOptions options = 0;
	
	for (NSString *o in array)
		if		([o isEqualToString:@"left"]) options |= NSLayoutFormatAlignAllLeft;
		else if ([o isEqualToString:@"right"]) options |= NSLayoutFormatAlignAllRight;
		else if ([o isEqualToString:@"top"]) options |= NSLayoutFormatAlignAllTop;
		else if ([o isEqualToString:@"bottom"])	options |= NSLayoutFormatAlignAllBottom;
		else if ([o isEqualToString:@"leading"]) options |= NSLayoutFormatAlignAllLeading;
		else if ([o isEqualToString:@"trailing"]) options |= NSLayoutFormatAlignAllTrailing;
		else if ([o isEqualToString:@"baseline"]) options |= NSLayoutFormatAlignAllBaseline;
		else if ([o isEqualToString:@"centerX"]) options |= NSLayoutFormatAlignAllCenterX;
		else if ([o isEqualToString:@"centerY"]) options |= NSLayoutFormatAlignAllCenterY;
		else if ([o isEqualToString:@"leadingToTrailing"]) options |= NSLayoutFormatDirectionLeadingToTrailing;
		else if ([o isEqualToString:@"leftToRight"]) options |= NSLayoutFormatDirectionLeftToRight;
		else if ([o isEqualToString:@"rightToLeft"]) options |= NSLayoutFormatDirectionRightToLeft;
		else if ([o isEqualToString:@"mask"]) options |= NSLayoutFormatAlignmentMask;
	
	return options;
}

#pragma mark -
#pragma mark view lifecycle

/* Render all the textual templates with the new object associated to the view.
 * Moreover it subscribes the view to object's properties changes. (for they keypaths that
 * are marked with the @bind keyword */
- (void)refreshView
{
    if (!_object) return;
    
    for (LTTarget *target in self.bindings) {      
        
        //static rendering of the textual template for the newly associated object
        [target.object setValue:LTRenderStringFromTemplate(target.template, self) forKeyPath:target.keypath];
        
        //cycle through all the template's keypaths
        for (NSUInteger i = 0; i < ((LTKVOTemplate*)target.template).keypaths.count; i++)
            
            //if the template is flagged as bound - that means that it requires KVO observation
            if ([((LTKVOTemplate*)target.template).flags[i] intValue] == kLTKVOFlagBound) {
                
                //get the right keypath value
                NSString *key = ((LTKVOTemplate*)target.template).keypaths[i];
        
                //subscribe self to the change of the object property
                [[self rac_subscribableForKeyPath:key onObject:self] subscribeNext:^(id x){
                    
                    //reload the template string
                    [target.object setValue:LTRenderStringFromTemplate(target.template, self) forKeyPath:target.keypath];
                    
                    //the context values are refreshed everytime a property change is observed
                    [self refreshContextBindings];
                }];
            }
    }
    
    [self refreshContextBindings];
}

/* Trigger the rendering of all the templates associated to the view's context
 * object. The context object binding is not mandatory.
 */
- (void)refreshContextBindings
{
    //cycle through all the targets for the context
    for (LTTarget *target in self.contextBindings) {
        
        //add the context condition values
        NSString *keypath = ((LTContextValueTemplate*)target.template).keypath;
        NSNumber *value = [_context valueForKey:keypath];
        [target.object setValue:value forKeyPath:target.keypath];
    }
}


@end
