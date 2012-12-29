//
//  NSMutableArray+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 12/29/12.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LTAdditions)

/* Normalizes the keys of the dictionaries containted by this array and all its
 * contained dictionaries recursively */
- (void)LT_normalizeKeys;

@end
