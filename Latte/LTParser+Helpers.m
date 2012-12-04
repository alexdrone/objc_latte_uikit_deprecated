//
//  LTParser+ViewInit.m
//  Latte
//
//  Created by Alex Usbergo on 7/14/12.
//
//

#import "LTPrefixes.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation LTParser (Helpers)

#pragma mark - Template Parsers 

/* Returns the possible condition value associated to the given string */
BOOL LTGetContextConditionFromString(LTContextValueTemplate **contextCondition, NSString* source)
{
    LTContextValueTemplate *obj = [LTContextValueTemplate createFromString:source];
    
    if (nil != obj)
        (*contextCondition) = obj;
    else
        (*contextCondition) = nil;
    
    return (nil != (*contextCondition));
}

/* Returns all the associated keypaths and a formatted (printable) string
 * from a given source string with the format
 * "This is a template #{obj.keypath} for #{otherkeypath}.." */
BOOL LTGetKeypathsAndTemplateFromString(NSArray **keypaths, NSString **template, NSString *source)
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#\\{([a-zA-Z0-9\\.\\@\\(\\)\\_]*)\\}"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:source options:0 range:NSMakeRange(0, source.length)];
    if (!matches.count) return NO;
    
    *keypaths = [NSMutableArray array];
    
    //iterating all the matches for the current line
    for (NSTextCheckingResult *match in matches)
        [(NSMutableArray*)*keypaths addObject:[source substringWithRange:[match rangeAtIndex:1]]];
    
    *template = [NSMutableString stringWithString:source];
    
    for (NSString *keypath in *keypaths)
        [(NSMutableString*)*template replaceOccurrencesOfString:[NSString stringWithFormat:@"#{%@}", keypath]
                                                     withString:@"%@"
                                                        options:NSLiteralSearch
                                                          range:NSMakeRange(0, (*template).length)];
    
    return YES;
}

#pragma mark - Primitive Type Parsers

/* These values are parsed at LTNode's creation time
 * Tries to parse the primitive latte values such
 * as fonts, color, rects and images. */
id LTParsePrimitive(id object, enum LTParsePrimitiveTypeOption option)
{
	id casted = object;

	if (![object isKindOfClass:NSString.class]) {
        LTLog(@"An object that is not a NSString has been passed as argument");
        return object;
    }
	
	//delays the parsification and the allocation of images to the actual view rendering
	if (option == LTParsePrimitiveTypeOptionOptimal && ([object hasPrefix:kLTTagColorPattern] || [object hasPrefix:kLTTagImage]))
		return object;
			
    if ([object hasPrefix:kLTTagColor])
        casted = [UIColor parseLatteColor:object];
		
	else if ([object hasPrefix:kLTTagFont])
		casted = [UIFont parseLatteFont:object];
		
	else if ([object hasPrefix:kLTTagImage])
		casted = [UIImage imageNamed:[object componentsSeparatedByString:kLTTagSeparator][1]];
    
    //else the object is considered a common NSString.
		
	return casted;
}

#pragma mark - Metric Types

/* Parses arrays that can be converted to CGPoint o CGRect. 
 * The content of the array is expected to be NSNumbers or LTMetricEvaluationTemplate */
id LTParseMetricArray(LTView *container, NSArray *object)
{
	id casted = [[NSValue alloc] init];
	
	//is a CGRect
	if ([object count] == 4)  {
		CGRect rect = CGRectMake([LTProcessMetricEvaluation(container, object[0]) floatValue],
								 [LTProcessMetricEvaluation(container, object[1]) floatValue],
								 [LTProcessMetricEvaluation(container, object[2]) floatValue],
								 [LTProcessMetricEvaluation(container, object[3]) floatValue]);
		casted = [NSValue valueWithCGRect:rect];
		
		//is a CGPoint
	} else if ([object count] == 2)  {
		CGPoint point = CGPointMake([LTProcessMetricEvaluation(container, object[0]) floatValue],
									[LTProcessMetricEvaluation(container, object[1]) floatValue]);
		casted = [NSValue valueWithCGPoint:point];
	
    } else {
        LTLog(@"Unknown type of metric array. Only CGRect, CGPoint and CGSize types are allowed.");
    }
	
	return casted;
}

/* Tries to evaluate a LTMetricEvaluationTemplate if passed
 * as argument or just return the value itself if it's a number */
NSNumber *LTProcessMetricEvaluation(LTView *container, id object)
{
	NSNumber *result = nil;
	
	if ([object isKindOfClass:LTMetricEvaluationTemplate.class])
		result = [object evalWithObject:container];
    
	else if ([object isKindOfClass:NSNumber.class])
        result = object;
	
	return nil != result ? result : @0;
}

/* Transform an array of option into the NSLayoutFormatOptions integer flag */
NSLayoutFormatOptions LTLayoutFormatOptionsFromArray(NSArray *array)
{
	if (nil == array) return 0;
	
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

@end
