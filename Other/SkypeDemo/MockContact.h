//
//  MockContact.h
//  Latte
//
//  Created by Alex Drone Usbergo on 23/09/12.
//
//

#import <Foundation/Foundation.h>

@interface MockContact : NSObject

@property (strong) NSString *displayname;
@property (strong) NSString *status;
@property (strong) NSString *imageURL;

+ (NSArray*)mockObjects;

@end
