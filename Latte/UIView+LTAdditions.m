//
//  UIView+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+LTAdditions.h"
#import <objc/runtime.h>
#import "LTPrefixes.h"

@implementation LTBind
@synthesize bind = _bind;

@end

static const char *kLTStyleKey = "LT_style";
static const char *kLTTagIdKey = "LT_id";

@implementation UIView (LTAdditions) 

@dynamic LT_style;
@dynamic LT_id;

- (void)setLT_id:(NSString *)LT_id
{
    objc_setAssociatedObject(self, kLTTagIdKey, LT_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLT_style:(NSString *)LT_style
{
    objc_setAssociatedObject(self, kLTStyleKey, LT_style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)LT_id
{
    id value = objc_getAssociatedObject(self, kLTTagIdKey);
    if (nil != value) return value;
    
    return @"#";
}

- (NSString*)LT_style
{
    id value = objc_getAssociatedObject(self, kLTStyleKey);
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

- (void)applyStyle:(NSString*)LT_style
{
    self.LT_style = LT_style;
    
    //get the dictionary from the shared stylesheet
    NSMutableDictionary *dict = [LTParser sharedInstance].sharedStyleSheetCache[LT_style];
    
    if (dict)
        LTStaticInitializeViewFromNodeDictionary(self,dict, nil, nil);
    
    //tries also .class#id
    dict = [LTParser sharedInstance].sharedStyleSheetCache[[NSString stringWithFormat:@"%@%@", self.LT_style, self.LT_id]];
    
    if (dict)
        LTStaticInitializeViewFromNodeDictionary(self, dict, nil, nil);
}

- (void)applyStyleRecursively:(NSString*)LT_style
{
    [self applyStyle:LT_style];
    
    for (UIView *subview in self.subviews)
        [subview applyStyleRecursively:LT_style];
}

@end
