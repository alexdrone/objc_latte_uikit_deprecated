//
//  LTLabel.m
//  Latte
//
//  Created by Alex Usbergo on 12/29/12.
//
//

#import "LTLabel.h"

@implementation LTLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {self.topInset, self.leftInset, self.bottomInset, self.rightInset};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
