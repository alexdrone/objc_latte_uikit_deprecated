//
//  DemoTableViewController.h
//  Latte
//
//  Created by Alex Usbergo on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoObject;
@class LTView;

@interface DemoCell : UITableViewCell {
    @private
    DemoObject *_object;
}

@property (strong) LTView *markupView;
@property (strong) DemoObject *object;

@end


@interface DemoTableViewController : UITableViewController <UITableViewDataSource> 

@property (strong) NSArray *objects;


@end
