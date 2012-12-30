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

@implementation LTParser

#pragma mark Singleton initialization code

+ (LTParser*)sharedInstance
{
    static dispatch_once_t pred;
    static LTParser *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[LTParser alloc] init];
    });
    
    return shared;
}

- (id)init
{
    if (self = [super init]) {
        self.cache = [[NSCache alloc] init];
        self.useJSONMarkup = YES;
    }        
    
    return self;
}

#pragma mark - Cache

/* Replaces the current caches for a given key */
- (void)replaceCacheForFile:(NSString*)key withNode:(LTNode*)node
{    
    [self.cache setObject:node forKey:key];
}

- (LTNode*)parseFile:(NSString*)filename;
{
    LTNode *node;
    if ((node = [self.cache objectForKey:filename]))
        return node;
    
    NSError *error = nil;
    
    NSString *extension = self.useJSONMarkup ? @"json" : @"latte";
    NSString *input = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:extension]
												encoding:NSUTF8StringEncoding 
												   error:&error];
	if (nil == input || nil != error) {
		LTLog(@"Unable to read the file %@", filename);
		return nil;
	}

	//parses the stylesheet if defied
	[[LTAppearance sharedInstance] parseFile:filename];
	
	//creates the hierarchy
	node = [self parseMarkup:input];
	
	LTLog(@"Recreating cache for key %@", filename);
	
	[self.cache setObject:node forKey:filename];
	return node;
}

#pragma mark - Parsing

/* Create the tree structure from a given legal .lt markup */
- (LTNode*)parseMarkup:(NSString*)markup
{
    return [self parseJSONMarkup:markup];
}

#pragma mark - JSON

- (LTNode*)parseJSONMarkup:(NSString*)markup
{
    NSError *error;
    NSMutableDictionary *json = [markup mutableObjectFromJSONStringWithParseOptions:JKParseOptionComments|JKParseOptionPermitTextAfterValidJSON error:&error];
	
	if (nil == json)
		LTLog(@"Unable to parse the json: %@", error.description);
    
    //makes sure that all the keys are in camelCase
    json = [[NSMutableDictionary alloc] initWithDictionary:json];
    [json LT_normalizeKeys];
	
    LTNode *rootNode = [[LTNode alloc] init];

    for (NSMutableDictionary *jsonRootNode in json[kLTTagLayout]) {
        
        //the child node is initialized a recursively created
        LTNode *node = [[LTNode alloc] init];
        LT_jsonCreateTreeStructure (jsonRootNode, node);
        
        //set the father of the node
        node.father = rootNode;
        [rootNode.children addObject:node];
    }
	
	//set the autolayout constraints if defined
	rootNode.constraints = json[kLTTagConstraints];

    return rootNode;
}

/* Recursively create the node structure from the JSON file */
void LT_jsonCreateTreeStructure(NSMutableDictionary *jsonNode, LTNode *node)
{
    NSArray *subiews = jsonNode[kLTTagSubviews];
    [jsonNode removeObjectForKey:kLTTagSubviews];
    
    node.data = jsonNode;
    
    for (NSMutableDictionary *jsonChildNode in subiews) {
        
        //the child node is initialized a recursively created
        LTNode *childNode = [[LTNode alloc] init];
        LT_jsonCreateTreeStructure(jsonChildNode, childNode);
        
        //set the father of the node
        childNode.father = node;
        [node.children addObject:childNode];
    }
}

/* Returns the possible condition value associated to the given string */
BOOL LT_parseContextConditionFromString(LTContextValueTemplate **contextCondition, NSString* source)
{
    LTContextValueTemplate *obj = [LTContextValueTemplate createFromString:source];
    
    if (nil != obj)
        (*contextCondition) = obj;
    else
        (*contextCondition) = nil;
    
    return (nil != (*contextCondition));
}

#pragma mark - Template parsers

/* Returns all the associated keypaths and a formatted (printable) string
 * from a given source string with the format
 * "This is a template #{obj.keypath} for #{otherkeypath}.." */
BOOL LT_parseKeypathsAndTemplateFromString(NSArray **keypaths, NSString **template, NSString *source)
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

#pragma mark - Primitive Type Parsers

/* These values are parsed at LTNode's creation time
 * Tries to parse the primitive latte values such
 * as fonts, color, rects and images. */
id LT_parsePrimitive(id object, enum LTParsePrimitiveTypeOption option)
{
	id casted = object;
    
	if (![object isKindOfClass:NSString.class]) {
        LTLog(@"An object that is not a NSString has been passed as argument");
        return object;
    }
	
	//delays the parsification and the allocation of images to the actual view rendering
	if (option == LTParsePrimitiveTypeOptionOptimal && ([object hasPrefix:kLTTagColorPattern] || [object hasPrefix:kLTTagImage]))
		return object;
    
    if ([object hasPrefix:kLTTagColor])
        casted = [UIColor LT_parseLatteColor:object];
    
	else if ([object hasPrefix:kLTTagFont])
		casted = [UIFont LT_parseLatteFont:object];
    
	else if ([object hasPrefix:kLTTagImage])
		casted = [UIImage imageNamed:[object LT_parseTaggedValue]];
    
    //else the object is considered a common NSString.
    
	return casted;
}

#pragma mark - Metric Types

/* Tries to evaluate a LTMetricEvaluationTemplate if passed
 * as argument or just return the value itself if it's a number */
NSNumber *LT_processMetricEvaluation(LTView *container, id object)
{
	NSNumber *result = nil;
	
	if ([object isKindOfClass:LTMetricEvaluationTemplate.class])
		result = [object evalWithObject:container];
    
	else if ([object isKindOfClass:NSNumber.class])
        result = object;
	
	return nil != result ? result : @0;
}


@end
