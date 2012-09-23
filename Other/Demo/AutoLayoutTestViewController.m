//
//  AutoLayoutTestViewController.m
//  Latte
//
//  Created by Alex Drone Usbergo on 23/09/12.
//
//

#import "AutoLayoutTestViewController.h"

@interface AutoLayoutTestViewController ()

@end

@implementation AutoLayoutTestViewController

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
	
	UILabel *l1 = [[UILabel alloc] init];
	l1.text = @"l1";
	l1.backgroundColor = [UIColor redColor];
	l1.textColor = [UIColor whiteColor];
	
	UILabel *l2 = [[UILabel alloc] init];
	l2.text = @"l2";
	l2.backgroundColor = [UIColor blueColor];
	l2.textColor = [UIColor whiteColor];

	[self.view addSubview:l1];
	[self.view addSubview:l2];
	
	NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(l1, l2);
	
	NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[l1(100)]-20-[l2(100)]" options:0 metrics:nil views:viewsDictionary];
	NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[l1(20)]-55-|"  options:0 metrics:nil views:viewsDictionary];


	[l1 setTranslatesAutoresizingMaskIntoConstraints:NO];
	[l2 setTranslatesAutoresizingMaskIntoConstraints:NO];


	[self.view addConstraints:constraints2];
	[self.view addConstraints:constraints3];

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
