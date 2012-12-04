//
//  LTNode.m
//  Latte
//
//  Created by Alex Usbergo on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LTPrefixes.h"

@implementation LTNode

/* global counter for all the node instances */
static NSUInteger LTNodeInstanceCounter = 0;

- (id)init
{
    if (self = [super init]) {
        _nodeId = [NSString stringWithFormat:@"%d", LTNodeInstanceCounter++];
        _children = [[NSMutableArray alloc] init];
        _data  = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

/* Simply returns the dictionary associated with 
 * this node */
- (NSMutableDictionary*)data
{
    return _data;
}

/* Set the node's data from a given KVC object.
 * All the keys that are marked with @bind got their
 * relationship saved as LTKVOTemplates so that is 
 * possible to recreate the binding at runtime */
- (void)setData:(NSMutableDictionary*)data
{
    _data = data;
    
    for (NSString *k in [_data allKeys]) {
		
		//the value
        id obj = _data[k];
        
        if ([obj isKindOfClass:NSString.class])
			_data[k] = [self processStringValue:obj];

		else if ([obj isKindOfClass:NSArray.class]) {
		
			NSMutableArray *objA = [NSMutableArray arrayWithArray:obj];
			
			for (NSUInteger i = 0; i < objA.count; i++)
				if ([objA[i] isKindOfClass:NSString.class])
					 objA[i] = [self processStringValue:objA[i]];

			_data[k] = objA;
		}
    }
}

/* Tries to process the string value in order 
 * to see if there's any latte markup in it and returns the correct
 * object for it */
- (id)processStringValue:(NSString*)obj
{
	id keypaths, template, processedObject = obj;
	LTContextValueTemplate *contextCondition = nil;
	
	//@metric expression
	if ([obj hasPrefix:kLTTagMetric]) {
		
		//tries to parse to split template and keypaths
		if (LT_parseKeypathsAndTemplateFromString(&keypaths, &template, obj))
			processedObject = [[LTMetricEvaluationTemplate alloc] initWithTemplate:template andKeypaths:keypaths];
		
        //@context-value
	} else if ([obj hasPrefix:kLTTagContext]) {
		
		//tries to parse to split template and keypaths
		if (LT_parseContextConditionFromString(&contextCondition, obj))
			processedObject = contextCondition;
        
        //common string template (with kvo bindings possibly)
	} else if (LT_parseKeypathsAndTemplateFromString(&keypaths, &template, obj)) {
		processedObject = [[LTKVOTemplate alloc] initWithTemplate:template andKeypaths:keypaths];
        
        //a common latte primitive type
	} else {
		processedObject = LT_parsePrimitive(obj, LTParsePrimitiveTypeOptionOptimal);
	}
	
	return processedObject;
}

/* Returns the node description with all its children */
- (NSString*)description
{
	NSMutableString *desc = [[NSMutableString alloc] init];
	[desc appendFormat:@"%@:%@", _nodeId, _data];
	
	if (self.children) {
		[desc appendFormat:@"\nchildren:\n"];
		
		for (LTNode *n in self.children)
			[desc appendString:n.description];
	}
	
	return desc;
}

@end

/* Creates a LTFormattedString with the given template (a string with the 
 * following format: "The string contains %@ different escapes %@") and
 * an array of keypaths.
 * LTKVOTemplate are defined in the markup as string with escape sequences such as:
 * "This is a #{key} for #{@bind(key2)}. 
 * All the keys relates to the LTView.object property. */
@implementation LTKVOTemplate

/* Creates a LTKVOTemplate with the given template (a string with the 
 * following format: "The string contains %@ different escapes %@") and
 * an array of keypaths */
- (id)initWithTemplate:(NSString*)template andKeypaths:(NSArray*)keypaths
{
    if (self = [super init]) {

        //@bind(
        NSString *bindPrefix = [NSString stringWithFormat:@"%@(", kLTTagBind];

        self.template = template;
        self.keypaths = [NSMutableArray arrayWithCapacity:keypaths.count];
        self.flags    = [NSMutableArray arrayWithCapacity:keypaths.count];
        
        for (NSUInteger k = 0; k < keypaths.count; k++) {
            NSString *keypath = keypaths[k];
            if ([keypath hasPrefix:bindPrefix] && keypath.length > bindPrefix.length + 2) {
                                
                NSString *trimmed = [keypath stringByReplacingOccurrencesOfString:bindPrefix withString:@""];
                trimmed = [trimmed stringByReplacingOccurrencesOfString:@")" withString:@""];
                //end
                
                [(NSMutableArray*)self.keypaths addObject:trimmed];
                [(NSMutableArray*)self.flags addObject:@(LTBindOptionBound)];
                
            } else {
                
                [(NSMutableArray*)self.keypaths addObject:keypath];
                [(NSMutableArray*)self.flags addObject:@(LTBindOptionNone)];
            }
        }
    }

    return self;
}

/* Render the template with the given object */
- (NSString*)renderWithObject:(LTView*)object
{
	NSMutableArray *values = [[NSMutableArray alloc] init];

		for (NSString *keypath in self.keypaths)
			[values addObject:[object valueForKeyPath:keypath]];
	
	return [NSString stringWithFormat:self.template array:values];
}

@end

/* Represent a target for the template substitution.
 * The template can be a LTKVOTemplate or a LTContextCondition.
 * The object represent the targetted view and the keypath 
 * the associated property */
@implementation LTTarget

- (id)initWithObject:(id)object keyPath:(NSString*)keypath andTemplate:(id)template
{
    if (self = [super init]) {
        self.object = object;
        self.keypath = keypath;
        self.template = template;
    }
    
    return self;
}

@end

/* It's a basic value substitution that fetches the values 
 * from the LTView.context property.
 * LTContextValueTemplate are re-rendered everytime that a new object is 
 * passed as argument to a LTView. 
 * In the markup they are defined with the @context keyword */
@implementation LTContextValueTemplate

/* Return a LTContextValueTemplate if the given string contains
 * a @context escaped value, nil otherwise */
+ (LTContextValueTemplate*)createFromString:(NSString*)keypath
{
    //@context(
    NSString *contextPrefix = [NSString stringWithFormat:@"%@(", kLTTagContext];
    
    if (![keypath hasPrefix:contextPrefix]) return nil;
    
    //tofix: ??? NSString *trimmed = [keypath substringWithRange:NSMakeRange(CONTEXT_PREFIX.length, keypath.length-2)];
    NSString *trimmed = [keypath stringByReplacingOccurrencesOfString:contextPrefix withString:@""];
    trimmed = [trimmed stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    LTContextValueTemplate *contextCondition = [[LTContextValueTemplate alloc] init];
    contextCondition.keypath = trimmed;

    return contextCondition;
}

- (id)renderWithObject:(LTContext*)object
{
	return [object valueForKey:self.keypath];
}

@end


/* Used to evaluate the expression defined with the @metric
 * keyword. The terms of the metrics expressions can be
 * refered to the components described in the markup file
 * by pointing at them through @id keyword */
@implementation LTMetricEvaluationTemplate 

/* Creates a LTMetricEvaluationTemplate with the given template (a string with the
 * following format: "The string contains %@ different escapes %@") and
 * an array of keypaths */
- (id)initWithTemplate:(NSString*)template andKeypaths:(NSArray*)keypaths
{
    if (self = [super init]) {
        
		NSString *trimmed = template;
		
        //@metric( prefix
		if ([template hasPrefix:kLTTagMetric]) {
			
			NSString *metricPrefix = [NSString stringWithFormat:@"%@(", kLTTagMetric];
			
			trimmed = [template stringByReplacingOccurrencesOfString:metricPrefix withString:@""];
			trimmed = [trimmed substringToIndex:trimmed.length-1];
		} 
		
        self.template = trimmed;
        self.keypaths = keypaths;
    }
    
    return self;
}

/* Render the template with the given object */
- (NSNumber*)evalWithObject:(LTView*)object
{
    @try {
        
        //extracts the values
        NSMutableArray *values = [NSMutableArray array];
        for (NSString *k in self.keypaths) {
		
			id target = object;
			NSString *keypath = k;
			
			//does it refer to a latte id?
			NSString *possibleIdName = [keypath componentsSeparatedByString:@"."][0];
			if ([object.viewsDictionary.allKeys containsObject:possibleIdName]) {
				
				//skips the id name + "."
				keypath = [keypath substringFromIndex:possibleIdName.length+1];
				target = object.viewsDictionary[possibleIdName];
				
				NSAssert(nil != target, @"Nil target for metric evaluation");
			}
			
            NSAssert([[target valueForKey:keypath] isKindOfClass:NSNumber.class], @"All the values should be NSNumbers");
            [values addObject:[target valueForKey:keypath]];
        }
        
        //render and compute the expression
        NSString *expression = [NSString stringWithFormat:self.template array:values];
        NSNumber *result = [[NSExpression expressionWithFormat:expression] expressionValueWithObject:nil context:nil];
        
        return result;
    }
    
    @catch (NSException *exception) {
        LTLog(@"Unable to render the template");
        return nil;
    }
}

@end
