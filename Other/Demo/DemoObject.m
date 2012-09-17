//
//  DemoObject.m
//  Latte
//
//  Created by Alex Usbergo on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoObject.h"

@implementation DemoObject

+ (NSMutableArray*)testCollection
{
    NSMutableArray *collection = [NSMutableArray array];
    DemoObject *obj;
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Alex";
    obj.lastname = @"Usbergo";
    obj.status = @"Soon in SanFrancisco";
    obj.picture = @"";
    obj.messages = 3;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Trent";
    obj.lastname = @"Reznor";
    obj.status = @"Nothing can stop me now";
    obj.picture = @"";
    obj.messages = 99;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Køre";
    obj.lastname = @"Andersson";
    obj.status = @"In Denmark next week";
    obj.picture = @"";
    obj.messages = 23;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Camilla";
    obj.lastname = @"Eleni";
    obj.status = @"Fuck my life!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Nils";
    obj.lastname = @"Rasmussen";
    obj.status = @"I love latte";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Roses";
    obj.lastname = @"Meg";
    obj.status = @"Roses are red and violets are blue";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Foo";
    obj.lastname = @"Bar";
    obj.status = @"Baz";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Pier";
    obj.lastname = @"Alisome";
    obj.status = @"Dubstep is cool";
    obj.picture = @"";
    obj.messages = 3;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Vodka";
    obj.lastname = @"Kalsniv";
    obj.status = @"I miss moscow";
    obj.picture = @"";
    obj.messages = 99;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"KøI";
    obj.lastname = @"Noble wopiess";
    obj.status = @"Super goood";
    obj.picture = @"";
    obj.messages = 23;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Anna";
    obj.lastname = @"Vander";
    obj.status = @"Whooot?!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Yolandi";
    obj.lastname = @"Visser";
    obj.status = @"ZEF Side!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Igor";
    obj.lastname = @"Johnosm";
    obj.status = @"Never trust penguings";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Venter";
    obj.lastname = @"Brown";
    obj.status = @"I love jazz!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Alex";
    obj.lastname = @"Usbergo";
    obj.status = @"Soon in SanFrancisco";
    obj.picture = @"";
    obj.messages = 3;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Trent";
    obj.lastname = @"Reznor";
    obj.status = @"Nothing can stop me now";
    obj.picture = @"";
    obj.messages = 99;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Køre";
    obj.lastname = @"Andersson";
    obj.status = @"In Denmark next week";
    obj.picture = @"";
    obj.messages = 23;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Camilla";
    obj.lastname = @"Eleni";
    obj.status = @"Fuck my life!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Nils";
    obj.lastname = @"Rasmussen";
    obj.status = @"I love latte";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Roses";
    obj.lastname = @"Meg";
    obj.status = @"Roses are red and violets are blue";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Foo";
    obj.lastname = @"Bar";
    obj.status = @"Baz";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Pier";
    obj.lastname = @"Alisome";
    obj.status = @"Dubstep is cool";
    obj.picture = @"";
    obj.messages = 3;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Vodka";
    obj.lastname = @"Kalsniv";
    obj.status = @"I miss moscow";
    obj.picture = @"";
    obj.messages = 99;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"KøI";
    obj.lastname = @"Noble wopiess";
    obj.status = @"Super goood";
    obj.picture = @"";
    obj.messages = 23;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Anna";
    obj.lastname = @"Vander";
    obj.status = @"Whooot?!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Yolandi";
    obj.lastname = @"Visser";
    obj.status = @"ZEF Side!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Igor";
    obj.lastname = @"Johnosm";
    obj.status = @"Never trust penguings";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    obj = [[DemoObject alloc] init];
    obj.firstname = @"Venter";
    obj.lastname = @"Brown";
    obj.status = @"I love jazz!";
    obj.picture = @"";
    obj.messages = 0;
    
    [collection addObject:obj];
    
    for (DemoObject *o in collection) {
        o.timestamp = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970] - (arc4random() % 60*60)];
    }
    
    return collection;
}

@end
