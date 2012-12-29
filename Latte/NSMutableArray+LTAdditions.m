//
//  NSMutableArray+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 12/29/12.
//
//

#import "NSMutableArray+LTAdditions.h"

@implementation NSMutableArray (LTAdditions)

/* Normalizes the keys of the dictionaries containted by this array and all its
 * contained dictionaries recursively */
- (void)LT_normalizeKeys
{
    for (NSUInteger i = 0; i < self.count; i++) {
        if ([self[i] isKindOfClass:NSDictionary.class] || [self[i] isKindOfClass:NSArray.class]) {
            self[i] = [self[i] mutableCopy];
            [self[i] LT_normalizeKeys];
        }
    }
}
    
@end
