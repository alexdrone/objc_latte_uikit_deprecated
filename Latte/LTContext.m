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
@property (strong) LTAppearance *appereance;

@end

@implementation LTContext

- (id)init
{
    if (self = [super init]) {
        
        self.keys = [[NSMutableDictionary alloc] init];
        self.appereance = [LTAppearance sharedInstance];
    }
    
    return self;
}

- (id)valueForKey:(NSString*)key
{
    return [self valueForKeyPath:key];
}

- (id)valueForKeyPath:(NSString*)keyPath
{
    LTContextEvalBlock block = self.keys[keyPath];
    
    if (nil != block) 
        return block();
    
    return @NO;
}

- (void)addContextEvaluation:(LTContextEvalBlock)block forKey:(NSString*)key;
{
    [self.keys setObject:block forKey:key];
}

@end
