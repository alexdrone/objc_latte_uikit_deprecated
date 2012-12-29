//
//  NSMutableDictionary+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 12/29/12.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (LTAdditions)

/* Normalizes the keys of this dictionary and all its
 * contained dictionaries recursively */
- (void)LT_normalizeKeys;

@end
