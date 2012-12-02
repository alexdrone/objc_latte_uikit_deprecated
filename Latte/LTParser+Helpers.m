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

@implementation LTParser (Helpers)

#pragma mark - Template Parsers 

/* Returns the possible condition value associated to the given string */
BOOL LTGetContextConditionFromString(LTContextValueTemplate **contextCondition, NSString* source)
{
    LTContextValueTemplate *obj = [LTContextValueTemplate createFromString:source];
    
    if (nil != obj)
        (*contextCondition) = obj;
    else
        (*contextCondition) = nil;
    
    return (nil != (*contextCondition));
}

/* Returns all the associated keypaths and a formatted (printable) string
 * from a given source string with the format
 * "This is a template #{obj.keypath} for #{otherkeypath}.." */
BOOL LTGetKeypathsAndTemplateFromString(NSArray **keypaths, NSString **template, NSString *source)
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#\\{([a-zA-Z0-9\\.\\@\\(\\)\\_]*)\\}"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:source options:0 range:NSMakeRange(0, source.length)];
    if (!matches.count) return NO;
    
    *keypaths = [NSMutableArray array];
    
    //iterating all the matches for the current line
    for (NSTextCheckingResult *match in matches)
        [(NSMutableArray*)*keypaths addObject:[source substringWithRange:[match rangeAtIndex:1]]];
    
    *template = [NSMutableString stringWithString:source];
    
    for (NSString *keypath in *keypaths)
        [(NSMutableString*)*template replaceOccurrencesOfString:[NSString stringWithFormat:@"#{%@}", keypath]
                                                     withString:@"%@"
                                                        options:NSLiteralSearch
                                                          range:NSMakeRange(0, (*template).length)];
    
    return YES;
}

/* Tries to evaluate a LTMetricEvaluationTemplate if passed
 * as argument or just return the value itself if it's a number */
NSNumber *LTProcessMetricEvaluation(LTView *container, id object)
{
	NSNumber *result = nil;
	
	if ([object isKindOfClass:LTMetricEvaluationTemplate.class]) {
		result = [object evalWithObject:container];
		
	} else {
		
		if ([object isKindOfClass:NSNumber.class])
			result = object;
	}
	
	return nil != result ? result : @0;
}

#pragma mark - Primitive Type Parsers

/* These values are parsed at LTNode's creation time
 * Tries to parse the primitive latte values such
 * as fonts, color, rects and images. */
id LTParsePrimitiveType(id object, enum LTParsePrimitiveTypeOption option)
{
	id casted = object;

	if (![object isKindOfClass:NSString.class])
		return object;
	
	//delays the parsification and the allocation of images to the actual view rendering
	if (option == LTParsePrimitiveTypeOptionOptimal && ([object hasPrefix:kLTTagColorPattern] || [object hasPrefix:kLTTagImage]))
		return object;
			
	//rgba color type
	if ([object hasPrefix:kLTTagColorRgb]) {
		
		NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
		NSArray  *comps = [value componentsSeparatedByString:@","];
		casted = LTRgbaUIColor([comps[0] floatValue], [comps[1] floatValue], [comps[2] floatValue], [comps[3] floatValue]);
		
	//hex color type
	} else if ([object hasPrefix:kLTTagColorHex]) {
		
		NSScanner *scanner = [NSScanner scannerWithString:object];
		NSUInteger result;
		[scanner setScanLocation:kLTTagColorHex.length+1];
		[scanner scanHexInt:&result];
		
		casted = LTHexUIColor(result);
		
	//pattern
	} else if ([object hasPrefix:kLTTagColorPattern]) {
		NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
		casted = [UIColor colorWithPatternImage:[UIImage imageNamed:value]];
		
	//ui color type
	} else if ([object hasPrefix:kLTTagColor]) {
		NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
		
		//add the color suffix if it's missing (in order to perform a call to the color method
		value = [value hasSuffix:@"Color"] ? value : [NSString stringWithFormat:@"%@Color", value];
		
		if (nil != class_getClassMethod(UIColor.class, NSSelectorFromString(value)))
			casted = [UIColor performSelector:NSSelectorFromString(value)];
		else
			casted = [UIColor blackColor];
		
	//font type
	} else if ([object hasPrefix:kLTTagFont]) {
		NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
		NSArray  *comps = [value componentsSeparatedByString:@","];
		casted = [UIFont fontWithName:comps[0] size:[comps[1] floatValue]];
		
	//image is still hardcoded
	} else if ([object hasPrefix:kLTTagImage]) {
		NSString *value = [object componentsSeparatedByString:kLTTagSeparator][1];
		casted = [UIImage imageNamed:value];
	}
		
	return casted;
}


/* Checks if the given aray contains just metric informations 
 * or not - other arrays are currently not supported */
BOOL LTIsAMetricArray(NSArray *object)
{
	BOOL result = YES;
	
	for (id val in object)
		if (!([val isKindOfClass:NSNumber.class] || [val isKindOfClass:LTMetricEvaluationTemplate.class]))
			result = NO;
	
	return result;
}

/* Parses arrays that can be converted to CGPoint o CGRect. 
 * The content of the array is expected to be NSNumbers or LTMetricEvaluationTemplate */
id LTParsePrimitiveTypeMetricArray(LTView *container, NSArray *object)
{
	id casted = object;
	
	//is a CGRect
	if ([object count] == 4)  {
		
		CGRect rect = CGRectMake([LTProcessMetricEvaluation(container, object[0]) floatValue],
								 [LTProcessMetricEvaluation(container, object[1]) floatValue],
								 [LTProcessMetricEvaluation(container, object[2]) floatValue],
								 [LTProcessMetricEvaluation(container, object[3]) floatValue]);
		
		casted = [NSValue valueWithCGRect:rect];
		
		//is a CGPoint
	} else if ([object count] == 2)  {
		
		CGPoint point = CGPointMake([LTProcessMetricEvaluation(container, object[0]) floatValue],
									[LTProcessMetricEvaluation(container, object[1]) floatValue]);
		
		casted = [NSValue valueWithCGPoint:point];
	}
	
	return casted;
}

/* Transform an array of option into the NSLayoutFormatOptions integer flag */
NSLayoutFormatOptions LTLayoutFormatOptionsFromArray(NSArray *array)
{
	if (!array) return 0;
	
	NSLayoutFormatOptions options = 0;
	
	for (NSString *o in array)
		if		([o isEqualToString:@"left"]) options |= NSLayoutFormatAlignAllLeft;
		else if ([o isEqualToString:@"right"]) options |= NSLayoutFormatAlignAllRight;
		else if ([o isEqualToString:@"top"]) options |= NSLayoutFormatAlignAllTop;
		else if ([o isEqualToString:@"bottom"])	options |= NSLayoutFormatAlignAllBottom;
		else if ([o isEqualToString:@"leading"]) options |= NSLayoutFormatAlignAllLeading;
		else if ([o isEqualToString:@"trailing"]) options |= NSLayoutFormatAlignAllTrailing;
		else if ([o isEqualToString:@"baseline"]) options |= NSLayoutFormatAlignAllBaseline;
		else if ([o isEqualToString:@"centerX"]) options |= NSLayoutFormatAlignAllCenterX;
		else if ([o isEqualToString:@"centerY"]) options |= NSLayoutFormatAlignAllCenterY;
		else if ([o isEqualToString:@"leadingToTrailing"]) options |= NSLayoutFormatDirectionLeadingToTrailing;
		else if ([o isEqualToString:@"leftToRight"]) options |= NSLayoutFormatDirectionLeftToRight;
		else if ([o isEqualToString:@"rightToLeft"]) options |= NSLayoutFormatDirectionRightToLeft;
		else if ([o isEqualToString:@"mask"]) options |= NSLayoutFormatAlignmentMask;
	
	return options;
}

#pragma mark - View Initialization

/* These values are parsed at LTView's creation time
 * Initialize the views by reading the Latte dictionary
 * passed as argument */
void LTStaticInitializeViewFromNodeDictionary(LTView *container, UIView *view, NSDictionary *dictionary,
											  NSMutableArray **bindings, NSMutableArray **contextBindings)
{
    for (NSString *key in dictionary.allKeys) {
        
        if ([key isEqualToString:kLTTagIsa]) continue;
        
        else if ([key isEqualToString:kLTTagId])
            view.LT_id = dictionary[key];
        
        else if ([key isEqualToString:kLTTagStyle])
            view.LT_style = dictionary[key];
        
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
            
            //metric evaluations are rendered in this stage
            } else if ([object isKindOfClass:LTMetricEvaluationTemplate.class]) {
                casted = LTProcessMetricEvaluation(container, object);
                continue;
            
			//primitives should be converted during the rendering
			} else if ([object isKindOfClass:NSArray.class] && LTIsAMetricArray(object)) {
				casted = LTParsePrimitiveTypeMetricArray(container, object);
				
			//if the value is still a string might be a lattekit primitive
			//type left to lazy initialization (likely an image)
			} else if ([object isKindOfClass:NSString.class]) {
				casted = LTParsePrimitiveType(object, LTParsePrimitiveTypeOptionNone);
			}
			
			//tries to set the object for the given key
            if ([view respondsToSelector:NSSelectorFromString(key)])
                [view setValue:casted forKeyPath:key];
        } 
    }
}

/* Render a view and all its subviews from a given node */
NSArray *LTRenderViewsFromNodeChildren(LTView *container, LTNode *node, NSMutableArray **bindings,
									   NSMutableArray **contextBindings, NSMutableDictionary *viewsDictionary)
{
    
#define ERR(fmt, ...) {NSLog((fmt), ##__VA_ARGS__); goto render_err;}
    
    //the rendered views
    NSMutableArray *views = [[NSMutableArray alloc] init];
	
    //recoursively creates all the views associated
    //to the nodes in the parse tree
    for (LTNode *n in node.children) {
		
        UIView *object = [[NSClassFromString(n.data[kLTTagIsa]) alloc] init];
		
        if (!object)
            ERR(@"Class %@ not found", n.data[kLTTagIsa]);
		
		//view dictionary to handle visual format languange constraints
		if (viewsDictionary && n.data[kLTTagId]) {
			
			NSString *viewId = n.data[kLTTagId];
			
			//the visual layout language is not compatible
			//with the # prefix
			if ([viewId hasPrefix:@"#"])
				viewId = [viewId substringFromIndex:1];
			
			viewsDictionary[viewId] = object;
		}
		
        @try {
            LTStaticInitializeViewFromNodeDictionary(container, object, n.data, bindings, contextBindings);
			
        } @catch (NSException *exception) {
            ERR(@"Unable to initialize the view with the node's data: %@", n.data);
        }
		
        //recoursively creates and add the subviews
        for (UIView *subview in LTRenderViewsFromNodeChildren(container, n, bindings, contextBindings, viewsDictionary))
            [object addSubview:subview];
		
		[views addObject:object];
    }
    
    return views;
    
render_err:
    LTLog(@"Rendering error");
    return nil;
}


@end
