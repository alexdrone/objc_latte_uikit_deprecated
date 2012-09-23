//
//  SkypeRecentViewController.m
//  Latte
//
//  Created by Alex Drone Usbergo on 23/09/12.
//
//

#import "SkypeRecentViewController.h"
#import "MockContact.h"
#import "SkypeRecentCell.h"

@interface SkypeRecentViewController ()

@property (strong) NSArray *contacts;

@end


@implementation SkypeRecentViewController

- (id)init
{
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		self.contacts = [MockContact mockObjects];
	}
	
	return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentSkypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell)
        cell = [[SkypeRecentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	
    ((SkypeRecentCell*)cell).object = [self.contacts objectAtIndex:indexPath.row];
    
    return cell;
}



@end
