//
//  NSString+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+LTAdditions.h"

@implementation NSString (LTAdditions)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*)args;
{
    NSRange range = NSMakeRange(0, [args count]);
    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [args count]];
    [args getObjects: (__unsafe_unretained id *)data.mutableBytes range:range];
    
    return [[NSString alloc] initWithFormat:format arguments:data.mutableBytes]; 
}

@end
