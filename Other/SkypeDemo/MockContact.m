//
//  MockContact.m
//  Latte
//
//  Created by Alex Drone Usbergo on 23/09/12.
//
//

#import "MockContact.h"

@implementation MockContact

static NSMutableArray *statuses;

+ (void)initialize
{
	statuses = [[NSMutableArray alloc] init];
	statuses[0] = @"Great. Say hi to Rich for me!";
	statuses[1] = @"No worries, the flight will take off later";
	statuses[2] = @"That's amazing! Send me the link";
	statuses[3] = @"Off to Sweden";
	statuses[4] = @"Congratz!!";
}


+ (NSArray*)mockObjects
{
	
	NSMutableArray *list = [[NSMutableArray alloc] init];

	MockContact *c = [[MockContact alloc] init];
	c.displayname = @"Aadi Kapoor";
	c.status = statuses[0];
	
	[list addObject:c];
	
	c = [[MockContact alloc] init];
	c.displayname = @"Beth Davies";
	c.status = statuses[1];
	
	[list addObject:c];
	
	c = [[MockContact alloc] init];
	c.displayname = @"Cathy Davies";
	c.status = statuses[2];
	
	[list addObject:c];
	
	c = [[MockContact alloc] init];
	c.displayname = @"Celine Gordon";
	c.status = statuses[3];
	
	c = [[MockContact alloc] init];
	c.displayname = @"Aaron Fitz";
	c.status = statuses[4];
	
	[list addObject:c];
	
	c = [[MockContact alloc] init];
	c.displayname = @"Alex Junior";
	c.status = statuses[1];
	
	[list addObject:c];
	
	c = [[MockContact alloc] init];
	c.displayname = @"Fitzgerald Gerald";
	c.status = statuses[2];
	
	[list addObject:c];
	
	c = [[MockContact alloc] init];
	c.displayname = @"Ashlee Housand";
	c.status = statuses[3];
	
	return list;
}

- (id)init
{
	if (self = [super init]) {
		[self performSelector:@selector(randStatus) withObject:nil afterDelay:1.f];
	}
	
	return self;
}

- (void)randStatus
{
	self.status = statuses[rand()%4];
	[self performSelector:@selector(randStatus) withObject:nil afterDelay:(rand()%20)*0.1f];
}

@end
