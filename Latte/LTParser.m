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
        _cache = [[NSCache alloc] init];
        _sharedStyleSheetCache = [[NSMutableDictionary alloc] init];
        _useJSONMarkup = YES;
    }        
    
    return self;
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
    
    NSString *extension = self.useJSONMarkup ? @"json" : @"latte";
    NSString *input = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:extension]
												encoding:NSUTF8StringEncoding 
												   error:&error];
    if (!error) {
        node = [self parseMarkup:input];
        
        if (DEBUG)
            NSLog(@"Cache: Recreating key for %@", filename);
        
        [self.cache setObject:node forKey:filename];
        return node;
    }
    
    else return nil;
}

#pragma mark Parsing

/* Create the tree structure from a given legal .lt markup */
- (LTNode*)parseMarkup:(NSString*)markup
{
    LTNode *result;
    
    if (self.useJSONMarkup)
        result = [self parseJSONMarkup:markup];
    else
        result = [self parseLatteMarkup:markup];
	    
    return result;
}

#pragma mark JSON

- (LTNode*)parseJSONMarkup:(NSString*)markup
{
    NSMutableDictionary *json = [markup mutableObjectFromJSONStringWithParseOptions:JKParseOptionComments];
    LTNode *rootNode = [[LTNode alloc] init];

    for (NSMutableDictionary *jsonRootNode in json[kLTTagLayout]) {
        
        //the child node is initialized a recursively created
        LTNode *node = [[LTNode alloc] init];
        LTJSONCreateTreeStructure (jsonRootNode, node);
        
        //set the father of the node
        node.father = rootNode;
        [rootNode.children addObject:node];
    }
	
	//set the autolayout constraints if defined
	rootNode.constraints = json[kLTTagConstraints];

    return rootNode;
}

/* Recursively create the node structure from the JSON file */
void LTJSONCreateTreeStructure(NSMutableDictionary *jsonNode, LTNode *node)
{
    NSArray *subiews = jsonNode[kLTTagSubviews];
    [jsonNode removeObjectForKey:kLTTagSubviews];
    
    node.data = jsonNode;
    
    for (NSMutableDictionary *jsonChildNode in subiews) {
        
        //the child node is initialized a recursively created
        LTNode *childNode = [[LTNode alloc] init];
        LTJSONCreateTreeStructure(jsonChildNode, childNode);
        
        //set the father of the node
        childNode.father = node;
        [node.children addObject:childNode];
    }
}

/* Parses the style section of the markup and initilizes LTStylesheet */
- (void)parseStylesheet:(NSString*)markup
{
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

#pragma mark Latte markup

/* Create the tree structure from a given legal .lt markup */
- (LTNode*)parseLatteMarkup:(NSString*)markup
{
    NSAssert(NO, @"Method currently unsupported");
    return nil;    
}


@end
