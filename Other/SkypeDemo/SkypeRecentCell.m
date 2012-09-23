//
//  SkypeRecentCell.m
//  Latte
//
//  Created by Alex Drone Usbergo on 23/09/12.
//
//

#import "SkypeRecentCell.h"
#import "LTPrefixes.h"
#import "MockContact.h"

@interface SkypeRecentCell ()
@property (nonatomic, strong) LTView *markupView;
@end

@implementation SkypeRecentCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
        self.markupView = [[LTView alloc] initWithLatteFile:@"SkypeRecentCell"];
        [self.contentView addSubview:self.markupView];
        
        self.markupView.frame = self.contentView.frame;
        self.markupView.clipsToBounds = YES;
    }
    
    return self;
}

- (void)setObject:(MockContact*)object
{
    _object = object;
    [self.markupView bind:object withContext:^(LTContext *context, id object) {

		[context addContextEvaluation:^id{
			
			if ([object status]) return @NO;
			return @YES;
			
		} forKey:@"hidden"];
	}];
}



@end
