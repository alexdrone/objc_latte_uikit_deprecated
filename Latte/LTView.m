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
    NSArray *subviews = LTRenderViewsFromNodeChildren(self, self.node, &map, &contextMap, self.viewsDictionary);
    
    self.bindings = map;
    self.contextBindings = contextMap;
    
    //remove all the previous subviews
    for (UIView *subview in self.subviews) 
        [subview removeFromSuperview];
    
    if (subviews.count)
        for (UIView *subview in subviews) {
			
			subview.LT_container = self;
            [self addSubview:subview];
			
			//tries to apply the style to the subview
			if (nil != subview.LT_style)
				[[LTAppearance sharedInstance] applyStyleWithName:subview.LT_style onView:subview overrideProperties:NO];
		}
	
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
        [target.object setValue:[target.template renderWithObject:self]  forKeyPath:target.keypath];
        
        //cycle through all the template's keypaths
        for (NSUInteger i = 0; i < ((LTKVOTemplate*)target.template).keypaths.count; i++)
            
            //if the template is flagged as bound - that means that it requires KVO observation
            if ([((LTKVOTemplate*)target.template).flags[i] intValue] == LTBindOptionBound) {
                
                //get the right keypath value
                NSString *key = ((LTKVOTemplate*)target.template).keypaths[i];
        
                //subscribe self to the change of the object property
                [[self rac_subscribableForKeyPath:key onObject:self] subscribeNext:^(id x){
                    
                    //reload the template string
                    [target.object setValue:[target.template renderWithObject:self] forKeyPath:target.keypath];
                    
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
    for (LTTarget *target in self.contextBindings)
        
        //add the context condition values
        [target.object setValue:[(LTContextValueTemplate*)target.template renderWithObject:_context]
					 forKeyPath:target.keypath];
}


@end
