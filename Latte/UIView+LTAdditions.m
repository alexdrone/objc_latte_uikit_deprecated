//
//  UIView+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+LTAdditions.h"
#import <objc/runtime.h>

@implementation LTBind
@synthesize bind = _bind;

-(void)drawRect:(CGRect)rect
{
    //do nothing
}

-(void)layoutSubviews
{
    //do nothing
}

@end

static const char *kLTClassKey = "LT_id";
static const char *kLTIdTagKey = "LT_class";

@implementation UIView (LTAdditions) 

@dynamic LT_class;
@dynamic LT_id;

- (void)setLT_id:(NSString *)LT_id
{
    objc_setAssociatedObject(self, kLTIdTagKey, LT_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLT_class:(NSString *)LT_class
{
    objc_setAssociatedObject(self, kLTClassKey, LT_class, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)LT_id
{
    id value = objc_getAssociatedObject(self, kLTIdTagKey);
    if (nil != value) return value;
    
    return @"#";
}

- (NSString *)LT_class
{
    id value = objc_getAssociatedObject(self, kLTClassKey);
    if (nil != value) return value;

    return @".";
}

- (UIView*)$:(NSString*)LT_id
{
    if (![LT_id hasPrefix:@"#"])
        LT_id = [NSString stringWithFormat:@"#%@", LT_id];
    
    for (UIView *subview in self.subviews)
        if ([subview.LT_id isEqualToString:LT_id]) return subview;
    
    for (UIView *subview in self.subviews) {
        UIView *ret = [subview $:LT_id];
        if (ret)
            return ret;
    }
    
    return nil;
}

@end
