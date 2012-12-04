//
//  LTContext.h
//  Latte
//
//  Created by Alex Usbergo on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^LTContextEvalBlock)(void);

@interface LTContext : NSObject

/* Adds a context evaluation block to the current context object.
 * Context object are used as wrappers for model logic (eg. if you want 
 * to display a string stating the number of object in a humanized way and use it in 
 * the json markup instead of the number itself).
 * {... "text":"@context(numberOfElements)" ..} where numberOfElements is the key 
 * for the context evaluation and the block perform the desired logic and returns 
 * the result */
- (void)addContextEvaluation:(LTContextEvalBlock)block forKey:(NSString*)key;


@end
