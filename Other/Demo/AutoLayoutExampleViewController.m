//
//  AutoLayoutExampleViewController.m
//  Latte
//
//  Created by Alex Drone Usbergo on 23/09/12.
//
//

#import "AutoLayoutExampleViewController.h"
#import "LTPrefixes.h"

@interface AutoLayoutExampleViewController ()

@end

@implementation AutoLayoutExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
	[super loadView];
	[self.view addSubview:[[LTView alloc] initWithLatteFile:@"AutoLayoutExample"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
