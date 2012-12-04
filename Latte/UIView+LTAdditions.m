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
#import <QuartzCore/QuartzCore.h>

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

- (UIView*)subviewWithId:(NSString*)LT_id
{
    if (![LT_id hasPrefix:@"#"])
        LT_id = [NSString stringWithFormat:@"#%@", LT_id];
    
    for (UIView *subview in self.subviews)
        if ([subview.LT_id isEqualToString:LT_id]) return subview;
    
    for (UIView *subview in self.subviews) {
        UIView *ret = [subview subviewWithId:LT_id];
        if (ret)
            return ret;
    }
    
    return nil;
}

#pragma mark - CGRect and CGPoint wrappers

- (NSNumber*)frameX
{
	return @(self.frame.origin.x);
}

- (NSNumber*)frameY
{
	return @(self.frame.origin.y);
}

- (NSNumber*)frameWidth
{
	return @(self.frame.size.width);
}

- (NSNumber*)frameHeight
{
	return @(self.frame.size.height);
}

- (NSNumber*)boundsX
{
	return @(self.bounds.origin.x);
}

- (NSNumber*)boundsY
{
	return @(self.bounds.origin.y);
}

- (NSNumber*)boundsWidth
{
	return @(self.bounds.size.width);
}

- (NSNumber*)boundsHeigth
{
	return @(self.bounds.size.height);
}

- (NSNumber*)positionX
{
	return @(self.bounds.size.height);
}

- (NSNumber*)positionY
{
	return @(self.bounds.size.height);
}

/* CALayer properties wrapper*/

#pragma mark - CALayer properties wrapper

- (NSNumber*)cornerRadius
{
    return @(self.layer.cornerRadius);
}

- (void)setCornerRadius:(NSNumber*)cornerRadius
{
    self.layer.cornerRadius = cornerRadius.floatValue;
    self.layer.masksToBounds = YES;
}

- (NSNumber*)borderWidth
{
    return @(self.layer.borderWidth);
}

- (void)setBorderWidth:(NSNumber*)borderWidth
{
    self.layer.borderWidth = borderWidth.floatValue;
}

- (UIColor*)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor*)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (NSNumber*)shadowOpacity
{
    return @(self.layer.shadowOpacity);
}

- (void)setShadowOpacity:(NSNumber*)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity.floatValue;
}

- (NSNumber*)shadowRadius
{
    return @(self.layer.shadowRadius);
}

- (void)setShadowRadius:(NSNumber*)shadowRadius
{
    self.layer.shadowRadius = shadowRadius.floatValue;
}

- (NSArray*)shadowOffset
{
    return @[@(self.layer.shadowOffset.width), @(self.layer.shadowOffset.height)];
}

- (void)setShadowOffset:(NSArray*)shadowOffset
{
    if (shadowOffset.count != 2) return;
    if (![shadowOffset[0] isKindOfClass:NSNumber.class] || ![shadowOffset[1] isKindOfClass:NSNumber.class]) return;
    self.layer.shadowOffset = CGSizeMake([shadowOffset[0] floatValue], [shadowOffset[1] floatValue]);
}

- (UIColor*)shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor*)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

@end
