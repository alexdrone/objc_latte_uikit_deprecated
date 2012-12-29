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
@end

static const char *kLTStyleKey = "LT_style";
static const char *kLTTagIdKey = "LT_id";
static const char *kLTTagContainerKey= "LT_container";

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

- (void)setLT_container:(LTView*)LT_container
{
    objc_setAssociatedObject(self, kLTTagContainerKey, LT_container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)LT_id
{
    id value = objc_getAssociatedObject(self, kLTTagIdKey);
    return value;
}

- (NSString*)LT_style
{
    id value = objc_getAssociatedObject(self, kLTStyleKey);
    return value;
}

- (NSString*)LT_container
{
    id value = objc_getAssociatedObject(self, kLTTagContainerKey);
    return value;
}

/* Recursively returns the view with the given @id */
- (UIView*)LT_subviewWithId:(NSString*)LT_id
{
    for (UIView *subview in self.subviews)
        if ([subview.LT_id isEqualToString:LT_id]) return subview;
    
    for (UIView *subview in self.subviews) {
        UIView *ret = [subview LT_subviewWithId:LT_id];
        if (ret)
            return ret;
    }
    
    return nil;
}

/* Applies the latte style defined in in the 
 * @stylesheet section to the current view */
- (void)LT_applyStyle:(NSString*)style
{
	[[LTAppearance sharedInstance] applyStyleWithName:style onView:self overrideProperties:YES];
}

/* Redirect to the wrapping object key, for example
 * autoresingMask is redirected to autoresizingMaskOptions */
+ (NSString*)LT_wrappingKeyForKey:(NSString*)key;
{
    if ([key isEqualToString:@"autoresizingMask"])
        return @"autoresizingMaskOptions";
    
    return key;
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

- (NSNumber*)maxX
{
    return @(CGRectGetMaxX(self.frame));
}

- (NSNumber*)maxY
{
    return @(CGRectGetMaxY(self.frame));
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

#pragma mark - Autoresizing mask options

- (void)setAutoresizingMaskOptions:(NSArray*)options
{
    UIViewAutoresizing option = UIViewAutoresizingNone;
    
    if ([options containsObject:@"leftMargin"])
        option |= UIViewAutoresizingFlexibleLeftMargin;
    
    if ([options containsObject:@"width"])
        option |= UIViewAutoresizingFlexibleWidth;
    
    if ([options containsObject:@"topMargin"])
        option |= UIViewAutoresizingFlexibleTopMargin;
    
    if ([options containsObject:@"rightMargin"])
        option |= UIViewAutoresizingFlexibleRightMargin;
    
    if ([options containsObject:@"height"])
        option |= UIViewAutoresizingFlexibleHeight;
    
    if ([options containsObject:@"bottomMargin"])
        option |= UIViewAutoresizingFlexibleBottomMargin;

    self.autoresizingMask = option;
}

-(NSArray*)autoresizingMaskOptions
{
    UIViewAutoresizing option = self.autoresizingMask;
    NSMutableArray *options = [NSMutableArray array];
    
    if (option & UIViewAutoresizingFlexibleLeftMargin)
        [options addObject:@"leftMargin"];

    if (option & UIViewAutoresizingFlexibleWidth)
        [options addObject:@"width"];

    if (option & UIViewAutoresizingFlexibleTopMargin)
        [options addObject:@"topMargin"];

    if (option & UIViewAutoresizingFlexibleRightMargin)
        [options addObject:@"rightMargin"];

    if (option & UIViewAutoresizingFlexibleHeight)
        [options addObject:@"height"];

    if (option & UIViewAutoresizingFlexibleBottomMargin)
        [options addObject:@"bottomMargin"];

    return options;
}

@end
