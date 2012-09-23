//
//  LTParser.h
//  Latte
//
//  Created by Alex Usbergo on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class LTNode;

#import <Foundation/Foundation.h>

@interface LTParser : NSObject

/* It's the stylesheet cache, shared among the entire application */
@property (strong) NSMutableDictionary *sharedStyleSheetCache;
@property (assign) BOOL useJSONMarkup;

+ (LTParser*)sharedInstance;

/* Replaces the current caches for a given key */
- (void)replaceCacheForFile:(NSString*)key withNode:(LTNode*)node;

/* Create the tree structure from a given legal .lt markup */
- (LTNode*)parseMarkup:(NSString*)markup; 
- (LTNode*)parseFile:(NSString*)filename;

/* Returns all the associated keypaths and a formatted (printable) string 
 * from a given source string with the format 
 * "This is a template #{obj.keypath} for #{otherkeypath}.." */
BOOL LTGetKeypathsAndTemplateFromString(NSArray **keypaths, NSString **template, NSString *source);

/* Returns the possible condition value associated to the given string */
BOOL LTGetContextConditionFromString(LTContextValueTemplate **contextCondition, NSString* source);

@end
