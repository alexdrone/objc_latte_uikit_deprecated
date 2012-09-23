//
//  LTParser+ViewInit.m
//  Latte
//
//  Created by Alex Usbergo on 7/14/12.
//
//

#import "LTPrefixes.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@implementation LTParser (ViewInit)

/* Initialize the views by reading the Latte dictionary
 * passed as argument */
void LTStaticInitializeViewFromNodeDictionary(UIView *view, NSDictionary *dictionary, NSMutableArray **bindings,
                                              NSMutableArray **contextBindings)
{
    for (NSString *key in dictionary.allKeys) {
        
        if ([key isEqualToString:@"LT_isa"]) continue;
        
        else if ([key isEqualToString:@"LT_id"])
            view.LT_id = dictionary[key];
        
        else if ([key isEqualToString:@"LT_class"])
            view.LT_class = dictionary[key];
        
        //reserved and special properties (syntactic sugar)
		if ([key isEqualToString:@"cornerRadius"]) {
			view.layer.cornerRadius = [dictionary[key] floatValue];
			view.layer.masksToBounds = YES;
            
            //text for buttons
        } else if ([key isEqualToString:@"text"] && [view isKindOfClass:UIButton.class]) {
			[((UIButton*)view) setTitle:dictionary[key] forState:UIControlStateNormal];
            
        } else {
            
            //normal properties
            id casted, object; casted = object = dictionary[key];
            
            //KVO bindings are skipped in this method
            if ([object isKindOfClass:LTKVOTemplate.class]) {
                [*bindings addObject:[[LTTarget alloc] initWithObject:view keyPath:key andTemplate:object]];
                continue;
                
                //Context Condition are skipped in this method
            } else if ([object isKindOfClass:LTContextValueTemplate.class]) {
                [*contextBindings addObject:[[LTTarget alloc] initWithObject:view keyPath:key andTemplate:object]];
                continue;
                
            } else if ([object isKindOfClass:NSString.class]) {
                
                //rgba color type
                if ([object hasPrefix:@"rgba:"] || [object hasPrefix:@"hsva:"]) {
                    
                    NSString *value = [object componentsSeparatedByString:@":"][1];
                    NSArray  *comps = [value componentsSeparatedByString:@","];
                    casted = LTRgbaUIColor([comps[0] floatValue], [comps[1] floatValue], [comps[2] floatValue], [comps[3] floatValue]);
                    
                    //hex color type
                } else if ([object hasPrefix:@"hex:"]) {
                    
                    NSScanner *scanner = [NSScanner scannerWithString:object];
                    NSUInteger result;
                    [scanner setScanLocation:6]; // bypass '#' character
                    [scanner scanHexInt:&result];
                    
                    casted = LTHexUIColor(result);
                    
                    //ui color type
                } else if ([object hasPrefix:@"uicolor:"]) {
                    NSString *value = [object componentsSeparatedByString:@":"][1];
                    
                    //add the color suffix if it's missing
                    if (![value hasSuffix:@"Color"])
                        value = [NSString stringWithFormat:@"%@Color", value];

                    if (nil != class_getClassMethod(UIColor.class, NSSelectorFromString(value)))
                        casted = [UIColor performSelector:NSSelectorFromString(value)];
                    else {
                        NSLog(@"Undefined color: %@", value);
                        casted = [UIColor blackColor];
                    }
                    
                    //pattern
                } else if ([object hasPrefix:@"pattern:"]) {
                    NSString *value = [object componentsSeparatedByString:@":"][1];
                    casted = [UIColor colorWithPatternImage:[UIImage imageNamed:value]];
                    
                    //font type
                } else if ([object hasPrefix:@"font-family:"]) {
                    NSString *value = [object componentsSeparatedByString:@":"][1];
                    NSArray  *comps = [value componentsSeparatedByString:@","];
                    casted = [UIFont fontWithName:comps[0] size:[comps[1] floatValue]];
                    
                    //image is still hardcoded
                } else if ([object hasPrefix:@"image:"]) {
                    NSString *value = [object componentsSeparatedByString:@":"][1];
                    casted = [UIImage imageNamed:value];
                }
                
            } else if ([object isKindOfClass:NSArray.class]) {
                
                //is a CGRect
                if ([object count] == 4)  {
                    CGRect rect = CGRectMake([object[0] floatValue], [object[1] floatValue], [object[2] floatValue], [object[3] floatValue]);
                    casted = [NSValue valueWithCGRect:rect];
                    
                    //is a CGPoint
                } else if ([object count] == 2)  {
                    CGPoint point = CGPointMake([object[0] floatValue], [object[1] floatValue]);
                    casted = [NSValue valueWithCGPoint:point];
                }
            }
            
            if ([view respondsToSelector:NSSelectorFromString(key)])
                [view setValue:casted forKeyPath:key];
        } 
    }
}

@end
