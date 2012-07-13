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


/* global enviroment properties */
@property (strong) NSDate *date;

- (void)addContextEvaluation:(LTContextEvalBlock)block forKey:(NSString*)key;


@end
