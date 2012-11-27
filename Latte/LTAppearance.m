//
//  LTAppearance.m
//  Latte
//
//  Created by Alex Usbergo on 9/17/12.
//
//

#import "LTPrefixes.h"

@implementation LTAppearance

#pragma mark Singleton initialization code

+ (LTAppearance*)sharedInstance
{
    static dispatch_once_t pred;
    static LTAppearance *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[LTAppearance alloc] init];
    });
    
    return shared;
}

- (id)init
{
    if (self = [super init]) {
        self.LTIsInterfaceIdiomiPad = @(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        self.LTIsInterfaceIdiomiPhone = @(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
        self.LTScreenBounds = [NSValue valueWithCGRect:[UIScreen mainScreen].bounds];
    }
    
    return self;
}


@end
