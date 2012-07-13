//
//  DemoVC.m
//  Latte
//
//  Created by Alex Usbergo on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoVC.h"

#import "LTPrefixes.h"



@implementation DemoVC

- (void)loadView
{
    [super loadView];
    _lt = [[LTView alloc] initWithLatteFile:@"Demo"];
    [self.view addSubview:_lt];
}

@end
