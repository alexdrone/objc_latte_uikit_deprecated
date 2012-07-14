//
//  LTLocale.m
//  Latte
//
//  Created by Alex Usbergo on 7/14/12.
//
//

#import "LTLocale.h"

@implementation LTLocale

+ (LTLocale*)sharedInstance
{
    static LTLocale *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LTLocale alloc] init];
    });
    return sharedInstance;
}

- (id)valueForKey:(NSString*)key
{
    return NSLocalizedString(key, @"");
}

@end
