//
//  LTButton.h
//  Latte
//
//  Created by Alex Usbergo on 12/20/12.
//
//

#import "FTWButton.h"

@interface LTButton : FTWButton

//background
@property (nonatomic, readwrite) UIColor *backgroundColorWhenNormal;
@property (nonatomic, readwrite) UIColor *backgroundColorWhenHighlighted;
@property (nonatomic, readwrite) UIColor *backgroundColorWhenDisabled;
@property (nonatomic, readwrite) UIColor *backgroundColorWhenSelected;

//border width
@property (nonatomic, readwrite) CGFloat borderWidthWhenNormal;
@property (nonatomic, readwrite) CGFloat borderWidthWhenHighlighted;
@property (nonatomic, readwrite) CGFloat borderWidthWhenDisabled;
@property (nonatomic, readwrite) CGFloat borderWidthWhenSelected;

//border color
@property (nonatomic, readwrite) UIColor *borderColorWhenNormal;
@property (nonatomic, readwrite) UIColor *borderColorWhenHighlighted;
@property (nonatomic, readwrite) UIColor *borderColorWhenDisabled;
@property (nonatomic, readwrite) UIColor *borderColorWhenSelected;

//corner Radius
@property (nonatomic, readwrite) CGFloat cornerRadiusWhenNormal;
@property (nonatomic, readwrite) CGFloat cornerRadiusWhenHighlighted;
@property (nonatomic, readwrite) CGFloat cornerRadiusWhenDisabled;
@property (nonatomic, readwrite) CGFloat cornerRadiusWhenSelected;

//icon
@property (nonatomic, readwrite) UIImage *iconWhenNormal;
@property (nonatomic, readwrite) UIImage *iconWhenHighlighted;
@property (nonatomic, readwrite) UIImage *iconWhenDisabled;
@property (nonatomic, readwrite) UIImage *iconWhenSelected;

//text
@property (nonatomic, readwrite) NSString *textWhenNormal;
@property (nonatomic, readwrite) NSString *textWhenHighlighted;
@property (nonatomic, readwrite) NSString *textWhenDisabled;
@property (nonatomic, readwrite) NSString *textWhenSelected;

//text color
@property (nonatomic, readwrite) UIColor *textColorWhenNormal;
@property (nonatomic, readwrite) UIColor *textColorWhenHighlighted;
@property (nonatomic, readwrite) UIColor *textColorWhenDisabled;
@property (nonatomic, readwrite) UIColor *textColorWhenSelected;

//text shadow offset
@property (nonatomic, readwrite) CGSize textShadowOffsetWhenNormal;
@property (nonatomic, readwrite) CGSize textShadowOffsetWhenHighlighted;
@property (nonatomic, readwrite) CGSize textShadowOffsetWhenDisabled;
@property (nonatomic, readwrite) CGSize textShadowOffsetWhenSelected;

//text shadow color
@property (nonatomic, readwrite) UIColor *textShadowColorWhenNormal;
@property (nonatomic, readwrite) UIColor *textShadowColorWhenHighlighted;
@property (nonatomic, readwrite) UIColor *textShadowColorWhenDisabled;
@property (nonatomic, readwrite) UIColor *textShadowColorWhenSelected;

//shadow color
@property (nonatomic, readwrite) UIColor *shadowColorWhenNormal;
@property (nonatomic, readwrite) UIColor *shadowColorWhenHighlighted;
@property (nonatomic, readwrite) UIColor *shadowColorWhenDisabled;
@property (nonatomic, readwrite) UIColor *shadowColorWhenSelected;

//shadow offset
@property (nonatomic, readwrite) CGSize shadowOffsetWhenNormal;
@property (nonatomic, readwrite) CGSize shadowOffsetWhenHighlighted;
@property (nonatomic, readwrite) CGSize shadowOffsetWhenDisabled;
@property (nonatomic, readwrite) CGSize shadowOffsetWhenSelected;

//shadow radius
@property (nonatomic, readwrite) CGFloat shadowRadiusWhenNormal;
@property (nonatomic, readwrite) CGFloat shadowRadiusWhenHighlighted;
@property (nonatomic, readwrite) CGFloat shadowRadiusWhenDisabled;
@property (nonatomic, readwrite) CGFloat shadowRadiusWhenSelected;

//shadow opacity
@property (nonatomic, readwrite) CGFloat shadowOpacityWhenNormal;
@property (nonatomic, readwrite) CGFloat shadowOpacityWhenHighlighted;
@property (nonatomic, readwrite) CGFloat shadowOpacityWhenDisabled;
@property (nonatomic, readwrite) CGFloat shadowOpacityWhenSelected;

//inner shadow color
@property (nonatomic, readwrite) UIColor *innerShadowColorWhenNormal;
@property (nonatomic, readwrite) UIColor *innerShadowColorWhenHighlighted;
@property (nonatomic, readwrite) UIColor *innerShadowColorWhenDisabled;
@property (nonatomic, readwrite) UIColor *innerShadowColorWhenSelected;

//inner shadow offset
@property (nonatomic, readwrite) CGSize innerShadowOffsetWhenNormal;
@property (nonatomic, readwrite) CGSize innerShadowOffsetWhenHighlighted;
@property (nonatomic, readwrite) CGSize innerShadowOffsetWhenDisabled;
@property (nonatomic, readwrite) CGSize innerShadowOffsetWhenSelected;

//inner shadow radius
@property (nonatomic, readwrite) CGFloat innerShadowRadiusWhenNormal;
@property (nonatomic, readwrite) CGFloat innerShadowRadiusWhenHighlighted;
@property (nonatomic, readwrite) CGFloat innerShadowRadiusWhenDisabled;
@property (nonatomic, readwrite) CGFloat innerShadowRadiusWhenSelected;

@end
