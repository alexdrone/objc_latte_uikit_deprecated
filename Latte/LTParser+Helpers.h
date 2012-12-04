//
//  LTParser+ViewInit.h
//  Latte
//
//  Created by Alex Usbergo on 7/14/12.
//
//

#import <UIKit/UIKit.h>
#import "LTParser.h"

NS_ENUM(NSUInteger, LTParsePrimitiveTypeOption) {
	LTParsePrimitiveTypeOptionOptimal,
	LTParsePrimitiveTypeOptionNone
};

@interface LTParser (Helpers)

// Templates parsers

/* Returns all the associated keypaths and a formatted (printable) string
 * from a given source string with the format
 * "This is a template #{obj.keypath} for #{otherkeypath}.." */
BOOL LTGetKeypathsAndTemplateFromString(NSArray **keypaths, NSString **template, NSString *source);

/* Returns the possible condition value associated to the given string */
BOOL LTGetContextConditionFromString(LTContextValueTemplate **contextCondition, NSString* source);

// Primitives parsers

/* Tries to parse the primitive latte values such
 * as fonts, color, rects and images. */
id LTParsePrimitive(id object, enum LTParsePrimitiveTypeOption option);

/* Parses arrays that can be converted to CGPoint o CGRect.
 * The content of the array is expected to be NSNumbers or LTMetricEvaluationTemplate */
id LTParseMetricArray(LTView *container, NSArray *object);

// Metric types

/* Tries to evaluate a LTMetricEvaluationTemplate if passed
 * as argument or just return the value itself if it's a number */
NSNumber *LTProcessMetricEvaluation(LTView *container, id object);

/* Transform an array of option into the NSLayoutFormatOptions integer flag */
NSLayoutFormatOptions LTLayoutFormatOptionsFromArray(NSArray *array);


@end
