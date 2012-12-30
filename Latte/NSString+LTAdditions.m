//
//  NSString+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+LTAdditions.h"
#import "LTPrefixes.h"

@implementation NSString (LTAdditions)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*)args;
{
    NSRange range = NSMakeRange(0, [args count]);
    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [args count]];
    [args getObjects: (__unsafe_unretained id *)data.mutableBytes range:range];
    
    return [[NSString alloc] initWithFormat:format arguments:data.mutableBytes]; 
}


- (NSString*)toUnderscoreCase
{
    NSMutableString *output = [NSMutableString string];
    NSCharacterSet *uppercase = [NSCharacterSet uppercaseLetterCharacterSet];
    
    for (NSInteger i = 0; i < self.length; i++) {
        
        unichar c = [self characterAtIndex:i];
        
        if ([uppercase characterIsMember:c])
            [output appendFormat:@"_%@", [[NSString stringWithCharacters:&c length:1] lowercaseString]];
        else
            [output appendFormat:@"%C", c];
    }
    
    return output;
}

- (NSString*)toCamelCase
{
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger i = 0; i < self.length; i++) {
        
        unichar c = [self characterAtIndex:i];
        
        if (c == '-') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

- (NSString*)LT_tagPrefix
{
    NSArray *comps = [self componentsSeparatedByString:kLTTagSeparator];
    NSAssert(nil != comps && comps.count == 2, @"Invalid value-string");
    return comps[0];
}

- (NSString*)LT_parseTaggedValue
{
    NSArray *comps = [self componentsSeparatedByString:kLTTagSeparator];
    NSAssert(nil != comps && comps.count == 2, @"Invalid value-string");
    
    NSString *value = comps[1];
    value = [value hasSuffix:kLTTagSeparatorEnd] ? [value substringToIndex:value.length-1] : value;
    return value;
}


@end
