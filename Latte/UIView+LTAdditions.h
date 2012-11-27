//
//  UIView+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTBind : UIView

@property (strong) NSString *bind;

@end

@interface UIView (LTAdditions)

@property (strong) NSString *LT_id;
@property (strong) NSString *LT_style;

- (UIView*)$:(NSString*)LT_id;
- (void)applyStyle:(NSString*)LT_style;
- (void)applyStyleRecursively:(NSString*)LT_style;

@end