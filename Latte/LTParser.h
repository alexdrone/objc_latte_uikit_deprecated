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

@property (assign) BOOL useJSONMarkup;

+ (LTParser*)sharedInstance;

/* Replaces the current caches for a given key */
- (void)replaceCacheForFile:(NSString*)key withNode:(LTNode*)node;

/* Create the tree structure from a given legal .lt markup */
- (LTNode*)parseMarkup:(NSString*)markup; 
- (LTNode*)parseFile:(NSString*)filename;

@end
