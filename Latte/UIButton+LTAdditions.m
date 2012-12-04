//
//  UIButton+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 12/4/12.
//
//

#import "UIButton+LTAdditions.h"

@implementation UIButton (LTAdditions)


- (NSString*)title
{
    return [self titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (UIColor*)titleColor
{
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor*)color 
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

@end
