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
+ (UIFont*)LT_parseLatteFont:(NSString*)object
{
    NSArray *comps = [[object LT_parseTaggedValue] componentsSeparatedByString:@","];
    
    if (comps.count != 2) {
        LTLog(@"@font not well-formed");
        return nil;
    }
    
    return [UIFont fontWithName:comps[0] size:[comps[1] floatValue]];
}

@end
