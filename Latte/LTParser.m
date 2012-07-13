//
//  LTParser.m
//  Latte
//
//  Created by Alex Usbergo on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LTPrefixes.h"

@interface LTParser ()

//caches the tree structure
@property (strong) NSCache *cache;

@end

static LTParser *sharedInstance = nil;

@implementation LTParser

@synthesize cache = _cache;
@synthesize sharedStyleSheetCache = _sharedStyleSheetCache;

#pragma mark Singleton initialization code

+ (LTParser*)sharedInstance
{
    if (sharedInstance) 
        return sharedInstance;
    
    return [[LTParser alloc] init];
}

- (id)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super init];
        if (sharedInstance) {
            _cache = [[NSCache alloc] init];
            _sharedStyleSheetCache = [[NSMutableDictionary alloc] init];
        }        
    });
    
    return sharedInstance;
}

#pragma mark Cache

/* Replaces the current caches for a given key */
- (void)replaceCacheForFile:(NSString*)key withNode:(LTNode*)node
{
    NSLog(@"Cache: Replacing key - %@", key);
    [self.cache setObject:node forKey:key];
}

- (LTNode*)parseFile:(NSString*)filename;
{
    LTNode *node;
    if ((node = [self.cache objectForKey:filename]))
        return node;
    
    NSError *error = nil;
    NSString *input = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType: @"latte"] 
												encoding:NSUTF8StringEncoding 
												   error:&error];
    if (!error) {
        node = [self parseMarkup:input];
        
        NSLog(@"Cache: Creating key - %@", filename);
        [self.cache setObject:node forKey:filename];
        return node;  
    }
    
    else return nil;
}

#pragma mark Parsing

/* Create the tree structure from a given legal .lt markup */
- (LTNode*)parseMarkup:(NSString*)markup
{
    NSArray *markups = [markup componentsSeparatedByString:@"@end"];
    NSUInteger idx = 0;
    
    if (markups.count > 1)
        [self parseStylesheet:markups[idx++]];
    
    markup = markups[idx];
    
    //nodes
    LTNode *rootNode, *currentNode, *fatherNode;
    rootNode = currentNode = [[LTNode alloc] init];
    fatherNode = nil;
    
    //syntax elements counters;
    NSInteger tabc = 0, tabo = -1;
    
    for (NSString *l in [markup componentsSeparatedByString:@"\n"]) {
    
        //skip all the empty lines and the comments
		NSString *trimmed = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([trimmed isEqualToString:@""] || [trimmed hasPrefix:@"-#"] || [trimmed hasPrefix:@"@layout"]) continue;
        
        //tab counts
        tabc = 0;
		for (int i = 0; i < l.length; i++)
            if ([l characterAtIndex:i] == '\t') tabc++;
			else break;
        
        //invalid indentation
		if (tabc >  tabo + 1) goto parse_err;
		
		//nested element
		if (tabc == tabo + 1) 
            fatherNode = currentNode;
		
		if (tabc < tabo)
			for (NSInteger i = 0; i < tabo-tabc; i++) 
				fatherNode = fatherNode.father;

		tabo = tabc;
        
        //text can be put as nested element
		if (![trimmed hasPrefix:@"%"]) {
            NSString *text = [NSString stringWithFormat:@"%@\n%@", [fatherNode.data objectForKey:@"text"], l];
            [fatherNode.data setObject:text forKey:@"text"];
            
            continue;
        } 
        
        //update the nodes hierarchy
        currentNode = [[LTNode alloc] init];
        currentNode.father = fatherNode;
        
        if (fatherNode) [fatherNode.children addObject:currentNode];
        
        //node content
		NSError *error = nil;
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"%([a-zA-z0-9]*)(\.[a-zA-z0-9]*)(\#[a-zA-z0-9]*)*\\{(.*)\\}"
																			   options:NSRegularExpressionCaseInsensitive
																				 error:&error];
        
        if (error) goto parse_err;
                
        //iterating all the matches for the current line
        for (NSTextCheckingResult *match in [regex matchesInString:l options:0 range:NSMakeRange(0, l.length)]) {
        
            NSString *latteIsa = [l substringWithRange:[match rangeAtIndex:1]];
            
			NSUInteger index = 2;
			NSString *latteClass = nil;
			if (match.numberOfRanges > index &&  [[l substringWithRange:[match rangeAtIndex:index]] hasPrefix:@"."]) 
				latteClass = [l substringWithRange:[match rangeAtIndex:index++]];
			
			NSString *latteId = nil;
			if (match.numberOfRanges > index &&  [[l substringWithRange:[match rangeAtIndex:index]] hasPrefix:@"#"]) 
				latteId = [l substringWithRange:[match rangeAtIndex:index++]];
			
			NSString *json = nil;
			if (match.numberOfRanges > index)
				json = [l substringWithRange:[match rangeAtIndex:index]];	
            
            NSMutableDictionary *data = [NSMutableDictionary dictionary];
            
            //get the values from the stylesheet
             [data addEntriesFromDictionary:self.sharedStyleSheetCache[[trimmed componentsSeparatedByString:@"{"][0]]];
            
            //and the values defined in the layout
            [data addEntriesFromDictionary:[[NSString stringWithFormat:@"{%@}",json] mutableObjectFromJSONString]];
            
            currentNode.data = data;
            
            if (latteClass) [currentNode.data setObject:latteClass forKey:@"LT_class"];
			if (latteId)	[currentNode.data setObject:latteId    forKey:@"LT_id"];
            if (latteIsa)   [currentNode.data setObject:latteIsa   forKey:@"LT_isa"];
            else goto parse_err;
        }
    }
    
    return rootNode;
    
//something went wrong
parse_err:
    NSLog(@"The markup is not latte compliant.");
    return nil;
}

/* Parses the style section of the markup and initilizes LTStylesheet */
- (void)parseStylesheet:(NSString*)markup
{
    //clear the cache
    [self.sharedStyleSheetCache removeAllObjects];
    
    @try {
        for (NSString *l in [markup componentsSeparatedByString:@"\n"]) {
            
            //skip all the empty lines and the comments
            NSString *trimmed = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([trimmed isEqualToString:@""] || [trimmed hasPrefix:@"-#"] || [trimmed hasPrefix:@"@style"]) continue;
            
            NSArray *comps = [trimmed componentsSeparatedByString:@"{"];
            
            NSString *selector = comps[0];
            NSDictionary *values = [[NSString stringWithFormat:@"{%@", [comps lastObject]] mutableObjectFromJSONString];
            
            self.sharedStyleSheetCache[selector] = values;
        }
    }
    
    @catch (NSException *exception) {
        NSLog(@"Corrupted stylesheet data");
    }
}

#pragma mark Helper functions

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
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#\\{([a-zA-Z0-9\\.\\@\\(\\)]*)\\}"
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

/*color helpers */
#define RGBAUICOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HSVAUICOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

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
                    casted = RGBAUICOLOR([comps[0] floatValue], [comps[1] floatValue], [comps[2] floatValue], [comps[3] floatValue]);
                    
                    //ui color type
                } else if ([object hasPrefix:@"uicolor:"]) {
                    NSString *value = [object componentsSeparatedByString:@":"][1];
                    casted = [UIColor performSelector:NSSelectorFromString(value)];
                    
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
                } else if ([object hasPrefix:@"image:bundle://"]) {
                    NSString *value = [object componentsSeparatedByString:@"://"][1];
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
