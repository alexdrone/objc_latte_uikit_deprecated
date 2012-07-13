//
//  DemoObject.h
//  Latte
//
//  Created by Alex Usbergo on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoObject : NSObject

+ (NSMutableArray*)testCollection;

@property (strong) NSString *firstname, *lastname, *status, *picture;
@property (assign) NSUInteger messages;
@property (strong) NSDate *timestamp;

@end
