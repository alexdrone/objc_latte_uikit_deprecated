//
//  LTNode.h
//  Latte
//
//  Created by Alex Usbergo on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTView;

@interface LTNode : NSObject {
    
    @private
    NSString *_nodeId;
    NSMutableDictionary *_data;
}

/* The superview of this node */
@property (strong) LTNode *father;

/* All the subviews of the element */
@property (strong) NSMutableArray *children;

/* The information about the node. (the json data related to it) */
@property (strong) NSMutableDictionary *data;

/* Autolayout visual constraints */
@property (strong) NSMutableArray *constraints;

@end

/* Options used in the LTKVOTemplate's flags */
NS_ENUM(BOOL, LTBindOption) {
	LTBindOptionNone,
	LTBindOptionBound
};

/* It represent a template for text formatting.
 * It's associated to the targetted object keypaths. */
@interface LTKVOTemplate: NSObject 

@property (strong) NSString *template;
@property (strong) NSArray *keypaths, *flags;
    
/* Creates a LTFormattedString with the given template (a string with the 
 * following format: "The string contains %@ different escapes %@") and
 * an array of keypaths.
 * LTKVOTemplate are defined in the markup as string with escape sequences such as:
 * "This is a #{key} for #{@bind(key2)}. 
 * All the keys relates to the LTView.object property. */
- (id)initWithTemplate:(NSString*)template andKeypaths:(NSArray*)keypaths;

/* Render the template with the given object */
- (NSString*)renderWithObject:(id)object;

@end

/* It's a basic value substitution that fetches the values 
 * from the LTView.context property.
 * LTContextValueTemplate are re-rendered everytime that a new object is 
 * passed as argument to a LTView. 
 * In the markup they are defined with the @context keyword */
@interface LTContextValueTemplate : NSObject

/* the context object associated keypath */
@property (strong) NSString *keypath;

/* Return a LTContextValueTemplate if the given string contains
 * a @context escaped value, nil otherwise */
+ (LTContextValueTemplate*)createFromString:(NSString*)source;

@end

/* Used to evaluate the expression defined with the @metric
 * keyword. The terms of the metrics expressions can be 
 * refered to the components described in the markup file 
 * by pointing at them through @id keyword */
@interface LTMetricEvaluationTemplate : NSObject

@property (strong) NSString *template;
@property (strong) NSArray *keypaths;

/* Return a LTMetricEvaluationTemplate if the given string contains
 * a @metric escaped value, nil otherwise */
- (id)initWithTemplate:(NSString*)template andKeypaths:(NSArray*)keypaths;

/* Render the template with the given object */
- (NSNumber*)evalWithObject:(id)object;

@end

/* Represent a target for the template substitution.
 * The template can be a LTKVOTemplate or a LTContextCondition.
 * The object represent the targetted view and the keypath 
 * the associated property */
@interface LTTarget : NSObject

/* the targetted UIView */
@property (strong) id object;

/* the targetted view's property */
@property (strong) NSString *keypath;

/* a LTKVOTextTemplate or a LTContextCondition */
@property (strong) id template;

- (id)initWithObject:(id)object keyPath:(NSString*)keypath andTemplate:(LTKVOTemplate*)template;

@end


