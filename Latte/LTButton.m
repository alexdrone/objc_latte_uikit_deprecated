//
//  LTButton.m
//  Latte
//
//  Created by Alex Usbergo on 12/20/12.
//
//

#import "LTButton.h"

@implementation LTButton

//background
- (void)setBackgroundColorWhenNormal:(UIColor*)background
{
    [super setBackgroundColor:background forControlState:UIControlStateNormal];
}
- (void)setBackgroundColorWhenHighlighted:(UIColor *)background
{
    [super setBackgroundColor:background forControlState:UIControlStateHighlighted];
}
- (void)setBackgroundColorWhenDisabled:(UIColor*)background
{
    [super setBackgroundColor:background forControlState:UIControlStateDisabled];
}
- (void)setBackgroundColorWhenSelected:(UIColor*)background
{
    [super setBackgroundColor:background forControlState:UIControlStateSelected];
}

//border color
- (void)setBorderColorWhenNormal:(UIColor *)color
{
    [super setBorderColor:color forControlState:UIControlStateNormal];
}
- (void)setBorderColorWhenHighlighted:(UIColor *)color
{
    [super setBorderColor:color forControlState:UIControlStateHighlighted];
}
- (void)setBorderColorWhenDisabled:(UIColor *)color
{
    [super setBorderColor:color forControlState:UIControlStateDisabled];
}
- (void)setBorderColorWhenSelected:(UIColor *)color
{
    [super setBorderColor:color forControlState:UIControlStateSelected];
}

//border width
- (void)setBorderWidthWhenNormal:(CGFloat)width
{
    [super setBorderWidth:width forControlState:UIControlStateNormal];
}
- (void)setBorderWidthWhenHighlighted:(CGFloat)width
{
    [super setBorderWidth:width forControlState:UIControlStateHighlighted];
}
- (void)setBorderWidthWhenDisabled:(CGFloat)width
{
    [super setBorderWidth:width forControlState:UIControlStateDisabled];
}
- (void)setBorderWidthWhenSelected:(CGFloat)width
{
    [super setBorderWidth:width forControlState:UIControlStateSelected];
}

//cornerRadius
- (void)setCornerRadiusWhenNormal:(CGFloat)radius
{
    [super setCornerRadius:radius forControlState:UIControlStateNormal];
}
- (void)setCornerRadiusWhenHighlighted:(CGFloat)radius
{
    [super setCornerRadius:radius forControlState:UIControlStateHighlighted];
}
- (void)setCornerRadiusWhenDisabled:(CGFloat)radius
{
    [super setCornerRadius:radius forControlState:UIControlStateDisabled];
}
- (void)setCornerRadiusWhenSelected:(CGFloat)radius
{
    [super setCornerRadius:radius forControlState:UIControlStateSelected];
}

//icon
- (void)setIconWhenNormal:(UIImage *)icon
{
    [super setIcon:icon forControlState:UIControlStateNormal];
}
- (void)setIconWhenHighlighted:(UIImage *)icon
{
    [super setIcon:icon forControlState:UIControlStateHighlighted];
}
- (void)setIconWhenDisabled:(UIImage *)icon
{
    [super setIcon:icon forControlState:UIControlStateDisabled];
}
- (void)setIconWhenSelected:(UIImage *)icon
{
    [super setIcon:icon forControlState:UIControlStateSelected];
}

//text
- (void)setTextWhenNormal:(NSString *)text
{
    [super setText:text forControlState:UIControlStateNormal];
}
- (void)setTextWhenHighlighted:(NSString *)text
{
    [super setText:text forControlState:UIControlStateHighlighted];
}
- (void)setTextWhenDisabled:(NSString *)text
{
    [super setText:text forControlState:UIControlStateDisabled];
}
- (void)setTextWhenSelected:(NSString *)text
{
    [super setText:text forControlState:UIControlStateSelected];
}

//text color
- (void)setTextColorWhenNormal:(UIColor *)color
{
    [super setTextColor:color forControlState:UIControlStateNormal];
}
- (void)setTextColorWhenHighlighted:(UIColor *)color
{
    [super setTextColor:color forControlState:UIControlStateHighlighted];
}
- (void)setTextColorWhenDisabled:(UIColor *)color
{
    [super setTextColor:color forControlState:UIControlStateDisabled];
}
- (void)setTextColorWhenSelected:(UIColor *)color
{
    [super setTextColor:color forControlState:UIControlStateSelected];
}

//text shadow offset
- (void)setTextShadowOffsetWhenNormal:(CGSize)offset
{
    [super setTextShadowOffset:offset forControlState:UIControlStateNormal];
}
- (void)setTextShadowOffsetWhenHighlighted:(CGSize)offset
{
    [super setTextShadowOffset:offset forControlState:UIControlStateHighlighted];
}
- (void)setTextShadowOffsetWhenDisabled:(CGSize)offset
{
    [super setTextShadowOffset:offset forControlState:UIControlStateDisabled];
}
- (void)setTextShadowOffsetWhenSelected:(CGSize)offset
{
    [super setTextShadowOffset:offset forControlState:UIControlStateSelected];
}

//text shadow color
- (void)setTextShadowColorWhenNormal:(UIColor *)color
{
    [super setTextShadowColor:color forControlState:UIControlStateNormal];
}
- (void)setTextShadowColorWhenHighlighted:(UIColor *)color
{
    [super setTextShadowColor:color forControlState:UIControlStateHighlighted];
}
- (void)setTextShadowColorWhenDisabled:(UIColor *)color
{
    [super setTextShadowColor:color forControlState:UIControlStateDisabled];
}
- (void)setTextShadowColorWhenSelected:(UIColor *)color
{
    [super setTextShadowColor:color forControlState:UIControlStateSelected];
}

//shadow color
- (void)setShadowColorWhenNormal:(UIColor *)color
{
    [super setShadowColor:color forControlState:UIControlStateNormal];
}
- (void)setShadowColorWhenHighlighted:(UIColor *)color
{
    [super setShadowColor:color forControlState:UIControlStateHighlighted];
}
- (void)setShadowColorWhenDisabled:(UIColor *)color
{
    [super setShadowColor:color forControlState:UIControlStateDisabled];
}
- (void)setShadowColorWhenSelected:(UIColor *)color
{
    [super setShadowColor:color forControlState:UIControlStateSelected];
}

//shadow offset
- (void)setShadowOffsetWhenNormal:(CGSize)offset
{
    [super setShadowOffset:offset forControlState:UIControlStateNormal];
}
- (void)setShadowOffsetWhenHighlighted:(CGSize)offset
{
    [super setShadowOffset:offset forControlState:UIControlStateHighlighted];
}
- (void)setShadowOffsetWhenDisabled:(CGSize)offset
{
    [super setShadowOffset:offset forControlState:UIControlStateDisabled];
}
- (void)setShadowOffsetWhenSelected:(CGSize)offset
{
    [super setShadowOffset:offset forControlState:UIControlStateSelected];
}

//shadow radius
- (void)setShadowRadiusWhenNormal:(CGFloat)radius
{
    [super setShadowRadius:radius forControlState:UIControlStateNormal];
}
- (void)setShadowRadiusWhenHighligthed:(CGFloat)radius
{
    [super setShadowRadius:radius forControlState:UIControlStateHighlighted];
}
- (void)setShadowRadiusWhenDisabled:(CGFloat)radius
{
    [super setShadowRadius:radius forControlState:UIControlStateDisabled];
}
- (void)setShadowRadiusWhenSelected:(CGFloat)radius
{
    [super setShadowRadius:radius forControlState:UIControlStateSelected];
}

//shadow opacity
- (void)setShadowOpacityWhenNormal:(CGFloat)opacity
{
    [super setShadowOpacity:opacity forControlState:UIControlStateNormal];
}
- (void)setShadowOpacityWhenHighlighted:(CGFloat)opacity
{
    [super setShadowOpacity:opacity forControlState:UIControlStateHighlighted];
}
- (void)setShadowOpacityWhenDisabled:(CGFloat)opacity
{
    [super setShadowOpacity:opacity forControlState:UIControlStateDisabled];
}
- (void)setShadowOpacityWhenSelected:(CGFloat)opacity
{
    [super setShadowOpacity:opacity forControlState:UIControlStateSelected];
}

//inner shadow color
- (void)setInnerShadowColorWhenNormal:(UIColor *)color
{
    [super setInnerShadowColor:color forControlState:UIControlStateNormal];
}
- (void)setInnerShadowColorWhenHighlighted:(UIColor *)color
{
    [super setInnerShadowColor:color forControlState:UIControlStateHighlighted];
}
- (void)setInnerShadowColorWhenDisabled:(UIColor *)color
{
    [super setInnerShadowColor:color forControlState:UIControlStateDisabled];
}
- (void)setInnerShadowColorWhenSelected:(UIColor *)color
{
    [super setInnerShadowColor:color forControlState:UIControlStateSelected];
}

//inner shadow offset
- (void)setInnerShadowOffsetWhenNormal:(CGSize)offset
{
    [super setInnerShadowOffset:offset forControlState:UIControlStateNormal];
}
- (void)setInnerShadowOffsetWhenHighlighted:(CGSize)offset
{
    [super setInnerShadowOffset:offset forControlState:UIControlStateHighlighted];
}
- (void)setInnerShadowOffsetWhenDisabled:(CGSize)offset
{
    [super setInnerShadowOffset:offset forControlState:UIControlStateDisabled];
}
- (void)setInnerShadowOffsetWhenSelected:(CGSize)offset
{
    [super setInnerShadowOffset:offset forControlState:UIControlStateSelected];
}

//inner shadow radius
- (void)setInnerShadowRadiusWhenNormal:(CGFloat)radius
{
    [super setInnerShadowRadius:radius forControlState:UIControlStateNormal];
}
- (void)setInnerShadowRadiusWhenHighlighted:(CGFloat)radius
{
    [super setInnerShadowRadius:radius forControlState:UIControlStateHighlighted];
}
- (void)setInnerShadowRadiusWhenDisabled:(CGFloat)radius
{
    [super setInnerShadowRadius:radius forControlState:UIControlStateDisabled];
}
- (void)setInnerShadowRadiusWhenSelected:(CGFloat)radius
{
    [super setInnerShadowRadius:radius forControlState:UIControlStateSelected];
}


@end

