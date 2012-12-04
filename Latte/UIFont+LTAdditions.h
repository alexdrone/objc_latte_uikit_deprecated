//
//  UIFont+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 12/4/12.
//
//

#import <UIKit/UIKit.h>

@interface UIFont (LTAdditions)

/* Parse a latte string with prefix @font into a UIFont */
+ (UIFont*)parseLatteFont:(NSString*)object;

@end
