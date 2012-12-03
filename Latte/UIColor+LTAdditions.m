//
//  UIColor+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 12/3/12.
//
//

#import "UIColor+LTAdditions.h"
#import "LTPrefixes.h"
#import <objc/runtime.h>

@implementation UIColor (LTAdditions)

+ (UIColor*)parseLatteColor:(NSString*)object
{
    id casted = [UIColor blackColor];
    
    if ([object hasPrefix:kLTTagColorRgb]) {
		casted = [UIColor colorFromLatteRgbString:object];
		
        //hex color type
	} else if ([object hasPrefix:kLTTagColorHex]) {
		casted = [UIColor colorFromLatteHexString:object];
		
        //pattern
	} else if ([object hasPrefix:kLTTagColorPattern]) {
		casted = [UIColor colorWithPatternImage:(id)object];
		
        //gradient color
    } else if ([object hasPrefix:kLTTagColorGradient]) {
        casted = [UIColor gradientColorFromLatteString:object];
        
        //ui color type
	} else if ([object hasPrefix:kLTTagColor]) {
        casted = [UIColor colorFromLatteSelectorName:object];
    }
    
    return casted;
}

+ (UIColor*)generateGradientFromColor:(UIColor*)color1 toColor:(UIColor*)color2 withSize:(CGSize)frame
{
    NSArray *colors = [NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, nil];
    
    // Allocate color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocate the gradients
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
    
    // Allocate bitmap context
    // The pattern is vertical - it doesn't require the whole width
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, 1., frame.height, 8, 4 * frame.width, colorSpace, kCGImageAlphaNoneSkipFirst);
    // Draw Gradient Here
    CGContextDrawLinearGradient(bitmapContext, gradient, CGPointMake(0.0f, 0.0f), CGPointMake(0, frame.height), kCGImageAlphaNoneSkipFirst);
    // Create a CGImage from context
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    // Create a UIImage from CGImage
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    // Release the CGImage
    CGImageRelease(cgImage);
    // Release the bitmap context
    CGContextRelease(bitmapContext);
    // Release the color space
    CGColorSpaceRelease(colorSpace);
    // Release the gradient
    CGGradientRelease(gradient);
    
    return [UIColor colorWithPatternImage:uiImage];
}

+ (UIColor*)colorFromLatteHexString:(NSString*)object
{
    NSScanner *scanner = [NSScanner scannerWithString:object];
    NSUInteger result;
    [scanner setScanLocation:kLTTagColorHex.length+1];
    [scanner scanHexInt:&result];

    return LTHexUIColor(result);
}

+ (UIColor*)colorFromLatteRgbString:(NSString *)object
{
    NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
    NSArray  *comps = [value componentsSeparatedByString:@","];
    return LTRgbaUIColor([comps[0] floatValue], [comps[1] floatValue], [comps[2] floatValue], [comps[3] floatValue]);
}

+ (UIColor*)colorFromLatteSelectorName:(NSString*)object
{
    id casted;
    
    NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
    
    //add the color suffix if it's missing (in order to perform a call to the color method
    value = [value hasSuffix:@"Color"] ? value : [NSString stringWithFormat:@"%@Color", value];
    
    if (nil != class_getClassMethod(UIColor.class, NSSelectorFromString(value)))
        casted = [UIColor performSelector:NSSelectorFromString(value)];
    else
        casted = [UIColor blackColor];
    
    return casted;
}

+ (UIColor*)colorFromLattePatternString:(NSString*)object
{
    NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
    return [UIColor colorWithPatternImage:[UIImage imageNamed:value]];
}

+ (UIColor*)gradientColorFromLatteString:(NSString*)object
{
    //trim the string
    NSString *value = [object substringFromIndex:kLTTagColorGradient.length+1];
    value = [value substringToIndex:value.length-1];
    
    //get the components
    NSArray *comps = [value componentsSeparatedByString:@","];
    
    NSUInteger color1, color2;

    NSScanner *scanner = [NSScanner scannerWithString:comps[0]];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&color1];
    
    scanner = [NSScanner scannerWithString:comps[1]];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&color2];
    
    
    CGFloat size = [comps[2] floatValue];
    
    return [UIColor generateGradientFromColor:LTHexUIColor(color1) toColor:LTHexUIColor(color2) withSize:CGSizeMake(size, size)];
}

@end
