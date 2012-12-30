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

- (NSString*)LT_parseTaggedValue
{
    NSArray *comps = [self componentsSeparatedByString:kLTTagSeparator];
    NSAssert(nil != comps && comps.count == 2, @"Invalid value-string");
    
    NSString *value = comps[1];
    value = [value hasSuffix:kLTTagSeparatorEnd] ? [value substringToIndex:value.length-1] : value;
    return value;
}

- (NSString*)LT_parseLatteFontAwesomeEnum
{
    return [self.class fontAwesomeIconStringForEnum:[self.class fontAwesomeEnumForIconIdentifier:[self LT_parseTaggedValue]]];
}

@end
