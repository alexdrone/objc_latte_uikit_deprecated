//
//  NSMutableDictionary+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 12/29/12.
//
//

#import "NSMutableDictionary+LTAdditions.h"
#import "NSString+LTAdditions.h"

@implementation NSMutableDictionary (LTAdditions)

- (void)LT_exchangeKey:(NSString*)aKey withKey:(NSString*)aNewKey
{
    if (![aKey isEqualToString:aNewKey]) {
        self[aNewKey] = self[aKey];
        [self removeObjectForKey:aKey];
    }
    
}

/* Normalizes the keys of this dictionary and all its 
 * contained dictionaries recursively */
- (void)LT_normalizeKeys
{
    for (NSString *key in self.allKeys) {
        
        // Transform all the keys to camel case
        NSString *camelCaseKey = [[NSString stringWithString:key] toCamelCase];
        [self LT_exchangeKey:key withKey:camelCaseKey];
        
        // Get the object for the new key and recursively performs
        // the transformation
        id obj = [self objectForKey:camelCaseKey];
        
        // Makes sure that the dictionary is mutable and normalizes the key
        if ([obj isKindOfClass:NSDictionary.class] || [obj isKindOfClass:NSArray.class]) {
            obj = [obj mutableCopy];
            self[camelCaseKey] = obj;
            [obj LT_normalizeKeys];   
        }
    }
    
}


@end
