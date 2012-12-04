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

/* Adds a context evaluation block to the current context object.
 * Context object are used as wrappers for model logic (eg. if you want
 * to display a string stating the number of object in a humanized way and use it in
 * the json markup instead of the number itself).
 * {... "text":"@context(numberOfElements)" ..} where numberOfElements is the key
 * for the context evaluation and the block perform the desired logic and returns
 * the result */
- (void)addContextEvaluation:(LTContextEvalBlock)block forKey:(NSString*)key;
{    
    self.keys[key] = block;
}

#pragma mark - KVC

- (id)valueForKey:(NSString*)key
{
    return [self valueForKeyPath:key];
}

- (id)valueForKeyPath:(NSString*)keyPath
{
    LTContextEvalBlock block = self.keys[keyPath];
    
    if (nil != block)
        return block();
    
    return [NSNull null];
}

@end
