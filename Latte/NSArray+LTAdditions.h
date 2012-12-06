//
//  NSArray+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 12/4/12.
//
//

#import <Foundation/Foundation.h>
@class LTView;

@interface NSArray (LTAdditions)

- (BOOL)LT_containsOnlyMetricObjects;

/* Transform the the current array in a NSValue 
 * suitable for a UIView. The only object that the array 
 * should contains are NSNumbers and LTMetricEvaluationTemplates. */
- (NSValue*)LT_createMetricForView:(LTView*)view;

/* Transform the array of string into a NSLayoutFormatOptions flag */
- (NSLayoutFormatOptions)LT_layoutFormatOptions;

@end
