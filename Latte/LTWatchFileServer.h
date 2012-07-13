//
//  LTMarkupInjector.h
//  Latte
//
//  Created by Alex Usbergo on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTView;

@interface LTWatchFileServer : NSObject

+ (LTWatchFileServer*)sharedInstance;

- (void)startOnPort:(NSUInteger)port;
- (void)stop;
- (void)registerView:(LTView*)view;
- (void)deregisterView:(LTView*)view;

@end
