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
@property (strong) LTAppearance *appearance;

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
        
        self.locale = [LTLocale sharedInstance];
        self.appearance = [LTAppearance sharedInstance];
        
        //parses and initializes the current view
        [self loadViewFromLatteFile:filename];
                    
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
    self.viewsDictionary = [[NSMutableDictionary alloc] init];
	
    //render the static components of the view    
    NSArray *subviews = [self createViewsForNode:self.node];
    
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
																	   options:[((NSArray*)c[@"options"]) LT_layoutFormatOptions]
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
 * object. The context object binding is not mandatory. */
- (void)refreshContextBindings
{
    //cycle through all the targets for the context
    for (LTTarget *target in self.contextBindings)
        
        //add the context condition values
        [target.object setValue:[(LTContextValueTemplate*)target.template renderWithObject:_context]
					 forKeyPath:target.keypath];
}

#pragma mark - 
#pragma mark View Rendering

/* These values are parsed at LTView's creation time
 * Initialize the views by reading the Latte dictionary passed as argument */
+ (void)initializeView:(UIView*)view fromNodeData:(NSDictionary*)dictionary inContainer:(LTView*)container
{
    for (NSString *key in dictionary.allKeys) {
        
        if ([key isEqualToString:kLTTagIsa]) continue;
        
        else if ([key isEqualToString:kLTTagId])
            view.LT_id = dictionary[key];
        
        else if ([key isEqualToString:kLTTagStyle])
            view.LT_style = dictionary[key];
        
        else {
            
            id object = dictionary[key];
            id casted = object;
                    
            //KVO bindings are skipped in this method
            if ([object isKindOfClass:LTKVOTemplate.class]) {
                [container.bindings addObject:[[LTTarget alloc] initWithObject:view keyPath:key andTemplate:object]];
                continue;
                
            //Context Condition are skipped in this method
            } else if ([object isKindOfClass:LTContextValueTemplate.class]) {
                [container.contextBindings addObject:[[LTTarget alloc] initWithObject:view keyPath:key andTemplate:object]];
                continue;
                
            //metric evaluations are rendered in this stage
            } else if ([object isKindOfClass:LTMetricEvaluationTemplate.class]) {
                casted = LT_processMetricEvaluation(container, object);
                continue;
                
            //primitives should be converted during the rendering
			} else if ([object isKindOfClass:NSArray.class] && [object LT_containsOnlyMetricObjects]) {
				casted = [((NSArray*)object) LT_createMetricForView:container];
				
            //if the value is still a string might be a lattekit primitive
            //type left to lazy initialization (likely an image)
			} else if ([object isKindOfClass:NSString.class]) {
				casted = LT_parsePrimitive(object, LTParsePrimitiveTypeOptionNone);
			}
			
            // Redirect to the wrapping object key, for example
            // autoresingMask is redirected to autoresizingMaskOptions
            NSString *keyPath = [self LT_wrappingKeyForKey:key];
            
			//tries to set the object for the given key
            if ([view respondsToSelector:NSSelectorFromString(keyPath)])
                [view setValue:casted forKeyPath:keyPath];
        }
    }
}

/* Render a view and all its subviews from a given node */
- (NSArray*)createViewsForNode:(LTNode*)node
{

#define ERR(fmt, ...) {LTLog((fmt), ##__VA_ARGS__); goto render_err;}
    
    
    //the rendered views
    NSMutableArray *views = [[NSMutableArray alloc] init];
	
    //recoursively creates all the views associated
    //to the nodes in the parse tree
    for (LTNode *n in node.children) {
		
        UIView *object = [[NSClassFromString(n.data[kLTTagIsa]) alloc] init];
		
        if (nil == object)
            ERR(@"Class %@ not found", n.data[kLTTagIsa]);
		
		//view dictionary to handle visual format languange constraints
        if (nil == n.data[kLTTagId])
            ERR(@"No @id for this view");
        
        self.viewsDictionary[n.data[kLTTagId]] = object;
		
        @try {
            
            //set all the properties from the node's data dictionary
            [self.class initializeView:object fromNodeData:n.data inContainer:self];
			
        } @catch (NSException *exception) {
            ERR(@"Unable to initialize the view with the node's data: %@", n.data);
        }
		
        //recoursively creates and add the subviews
        for (UIView *subview in [self createViewsForNode:n])
            [object addSubview:subview];
		
		[views addObject:object];
    }
    
    //returns the generated views
    return views;
    
render_err:
    LTLog(@"Rendering error");
    return @[];
}

@end
