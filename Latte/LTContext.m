//
//  LTContext.m
//  Latte
//
//  Created by Alex Usbergo on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LTPrefixes.h"

@interface LTContext () 

@property (strong) NSMutableDictionary *keys;

@end

@implementation LTContext

@synthesize keys = _keys;
@synthesize date = _date;

- (id)init
{
    if (self = [super init]) {
        _keys = [[NSMutableDictionary alloc] init];
        
        [self performSelector:@selector(updateDate)];
    }
    
    return self;
}

- (id)valueForKey:(NSString*)key
{
    return [self valueForKeyPath:key];
}

- (id)valueForKeyPath:(NSString*)keyPath
{
    LTContextEvalBlock block = _keys[keyPath];
    
    if (nil != block) 
        return block();
    
    return @NO;
}

- (void)addContextEvaluation:(LTContextEvalBlock)block forKey:(NSString*)key;
{
    [_keys setObject:block forKey:key];
}

- (void)updateDate
{
    self.date = [NSDate date];
    [self performSelector:@selector(updateDate) withObject:nil afterDelay:1.0];
}
@end
