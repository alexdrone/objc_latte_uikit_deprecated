//
//  LTAppearance.h
//  Latte
//
//  Created by Alex Usbergo on 9/17/12.
//
//

#import <Foundation/Foundation.h>

@interface LTAppearance : NSObject

+ (LTAppearance*)sharedInstance;

/* Add to the current stylesheet the values read from 
 * the stylesheet file */
- (void)readStylesheetNamed:(NSString*)stylesheet;

/* Manually set the given JSON dictionary of style 
 * for the given filename. The filename is important 
 * in order to be able to replace it real-time if the content
 * changes (via LTWatchFileServer) */
- (void)setStylesheet:(NSMutableDictionary*)json forKey:(NSString*)filename;

/* A flatten dictionary of all the declared styles 
 * with their value */
@property (strong) NSMutableDictionary *stylesheet;

@property (readonly) NSNumber *screenWidth;
@property (readonly) NSNumber *screenHeight;
@property (readonly) NSNumber *isPad;
@property (readonly) NSNumber *isPhone;

@end
