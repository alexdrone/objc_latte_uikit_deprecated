//
//  LTAppearance.h
//  Latte
//
//  Created by Alex Usbergo on 9/17/12.
//
//

#import <Foundation/Foundation.h>

#pragma mark Macro helpers

#define LTRgbaUIColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define LTHvsaUIColor(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]
#define LTHexUIColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LTAppearance : NSObject

+ (LTAppearance*)sharedInstance;

@property (strong) NSValue  *LTScreenBounds;
@property (strong) NSNumber *LTIsInterfaceIdiomiPad;
@property (strong) NSNumber *LTIsInterfaceIdiomiPhone;

@end
