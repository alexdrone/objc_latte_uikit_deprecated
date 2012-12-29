//
//  NSArray+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 12/4/12.
//
//

#import "NSArray+LTAdditions.h"
#import "LTPrefixes.h"
#import "NSMutableDictionary+LTAdditions.h"

@implementation NSArray (LTAdditions)

- (BOOL)LT_containsOnlyMetricObjects
{
    BOOL result = YES;
    for (id obj in self)
        if (!([obj isKindOfClass:NSNumber.class] || [obj isKindOfClass:LTMetricEvaluationTemplate.class])) {
            result = NO;
            break;
        }
            
    return result;
}

/* Transform the the current array in a NSValue
 * suitable for a UIView. The only object that the array
 * should contains are NSNumbers and LTMetricEvaluationTemplates. */
- (NSValue*)LT_createMetricForView:(LTView*)view
{
    NSValue *casted = [[NSValue alloc] init];

	if (![self LT_containsOnlyMetricObjects]) {
        LTLog(@"The array doesn't contain just metric objects (instances of NSNumber or LTMetricEvaluationTemplate)");
        return casted;
    }
    
	//is a CGRect
	if (self.count == 4)  {
		CGRect rect = CGRectMake([LT_processMetricEvaluation(view, self[0]) floatValue],
								 [LT_processMetricEvaluation(view, self[1]) floatValue],
								 [LT_processMetricEvaluation(view, self[2]) floatValue],
								 [LT_processMetricEvaluation(view, self[3]) floatValue]);
		casted = [NSValue valueWithCGRect:rect];
		
		//is a CGPoint
	} else if (self.count == 2)  {
		CGPoint point = CGPointMake([LT_processMetricEvaluation(view, self[0]) floatValue],
									[LT_processMetricEvaluation(view, self[1]) floatValue]);
		casted = [NSValue valueWithCGPoint:point];
        
    } else {
        LTLog(@"Unknown type of metric array. Only CGRect, CGPoint and CGSize types are allowed.");
    }
	
	return casted;
}

/* Transform the array of string into a NSLayoutFormatOptions flag */
- (NSLayoutFormatOptions)LT_layoutFormatOptions
{
	if (nil == self) return 0;
	
	NSLayoutFormatOptions options = 0;
	
	for (NSString *o in self)
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
