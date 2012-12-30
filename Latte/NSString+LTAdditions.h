//
//  NSString+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LTAdditions)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*)args;

- (NSString*)LT_parseTaggedValue;
- (NSString*)LT_parseLatteFontAwesomeEnum;

@end
