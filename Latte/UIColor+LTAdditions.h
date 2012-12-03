//
//  UIColor+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 12/3/12.
//
//

#import <UIKit/UIKit.h>

#pragma mark Macro helpers

#define LTRgbaUIColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define LTHvsaUIColor(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]
#define LTHexUIColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (LTAdditions)

+ (UIColor*)parseLatteColor:(NSString*)object;

+ (UIColor*)colorFromLatteHexString:(NSString*)object;
+ (UIColor*)colorFromLatteRgbString:(NSString*)object;
+ (UIColor*)colorFromLatteSelectorName:(NSString*)object;
+ (UIColor*)colorFromLattePatternString:(NSString*)object;
+ (UIColor*)gradientColorFromLatteString:(NSString*)object;


@end
