//
//  UIFont+LTAdditions.m
//  Latte
//
//  Created by Alex Usbergo on 12/4/12.
//
//

#import "UIFont+LTAdditions.h"
#import "LTPrefixes.h"

@implementation UIFont (LTAdditions)

/* Parse a latte string with prefix @font into a UIFont */
+ (UIFont*)parseLatteFont:(NSString*)object
{
    NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
    NSArray  *comps = [value componentsSeparatedByString:@","];
    return [UIFont fontWithName:comps[0] size:[comps[1] floatValue]];
}

@end
