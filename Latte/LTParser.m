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
	if (nil == input)
		LTLog(@"Unable to read the file %@", filename);
	
    if (!error) {
        node = [self parseMarkup:input];
        
		LTLog(@"Recreating cache for key %@", filename);
        
        [self.cache setObject:node forKey:filename];
        return node;
    }
    
    else return nil;
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
    NSMutableDictionary *json = [markup mutableObjectFromJSONStringWithParseOptions:JKParseOptionComments|JKParseOptionPermitTextAfterValidJSON];
	
	if (nil == json)
		LTLog(@"Unable to parse the json");
	
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


@end
