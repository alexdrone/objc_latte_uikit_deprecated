//
//  DemoTableViewController.m
//  Latte
//
//  Created by Alex Usbergo on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoTableViewController.h"
#import "LTPrefixes.h"
#import "DemoObject.h"

@implementation DemoCell

@synthesize markupView = _markupView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.markupView = [[LTView alloc] initWithLatteFile:@"DemoCell"];
        [self.contentView addSubview:self.markupView];
        
        self.markupView.frame = self.contentView.frame;
        self.markupView.clipsToBounds = YES;
    }
    
    return self;
}

- (DemoObject*)object
{
    return _object;
}

- (void)setObject:(DemoObject*)object
{
    _object = object;
    [self.markupView bind:object withContext:^(LTContext *context, id object) {
        
        [context addContextEvaluation:^id{
            return [NSNumber numberWithBool:([object messages] == 0)];
        } forKey:@"hideCount"];
    }];
    
    UIView *v = [self.markupView $:@"test"];
    NSLog(@"%@", v);
}

@end


@implementation DemoTableViewController

@synthesize objects = _objects;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.objects = [DemoObject testCollection];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self updateMessagesCount];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell)
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    ((DemoCell*)cell).object = [self.objects objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)updateMessagesCount
{
    NSUInteger index = arc4random() % self.objects.count;
    DemoObject *obj = [self.objects objectAtIndex:index];
    obj.messages = arc4random() % 10;
    
    NSUInteger otherIndex = arc4random() % self.objects.count;
    DemoObject *otherObj = [self.objects objectAtIndex:otherIndex];
    
    NSString *swap = obj.status;
    
    obj.status = otherObj.status;
    otherObj.status = swap;

    [self performSelector:@selector(updateMessagesCount) withObject:nil afterDelay:0.1];
}


@end
