//
//  LTParser.h
//  Latte
//
//  Created by Alex Usbergo on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class LTNode;

#import <Foundation/Foundation.h>

NS_ENUM(NSUInteger, LTParsePrimitiveTypeOption) {
	LTParsePrimitiveTypeOptionOptimal,
	LTParsePrimitiveTypeOptionNone
};

@interface LTParser : NSObject

@property (assign) BOOL useJSONMarkup;

+ (LTParser*)sharedInstance;

/* Replaces the current caches for a given key */
- (void)replaceCacheForFile:(NSString*)key withNode:(LTNode*)node;

/* Create the tree structure from a given legal .lt markup */
- (LTNode*)parseMarkup:(NSString*)markup; 
- (LTNode*)parseFile:(NSString*)filename;

// Templates parsers

/* Returns all the associated keypaths and a formatted (printable) string
 * from a given source string with the format
 * "This is a template #{obj.keypath} for #{otherkeypath}.." */
BOOL LT_parseKeypathsAndTemplateFromString(NSArray **keypaths, NSString **template, NSString *source);

/* Returns the possible condition value associated to the given string */
BOOL LT_parseContextConditionFromString(LTContextValueTemplate **contextCondition, NSString* source);

// Primitives parsers

/* Tries to parse the primitive latte values such
 * as fonts, color, rects and images. */
id LT_parsePrimitive(id object, enum LTParsePrimitiveTypeOption option);

/* Tries to evaluate a LTMetricEvaluationTemplate if passed
 * as argument or just return the value itself if it's a number */
NSNumber *LT_processMetricEvaluation(LTView *container, id object);

@end
