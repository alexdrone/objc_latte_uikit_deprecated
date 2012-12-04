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

/* CGRect and CGPoint wrappers */
@property (readonly) NSNumber *frameX;
@property (readonly) NSNumber *frameY;
@property (readonly) NSNumber *frameWidth;
@property (readonly) NSNumber *frameHeight;
@property (readonly) NSNumber *boundsX;
@property (readonly) NSNumber *boundsY;
@property (readonly) NSNumber *boundsWidth;
@property (readonly) NSNumber *boundsHeigth;
@property (readonly) NSNumber *positionX;
@property (readonly) NSNumber *positionY;

/* CALayer properties wrapper*/
@property (strong) NSNumber *cornerRadius;
@property (strong) NSNumber *borderWidth;
@property (strong) UIColor *borderColor;
@property (strong) NSNumber *shadowOpacity;
@property (strong) NSNumber *shadowRadius;
@property (strong) NSArray *shadowOffset;
@property (strong) UIColor *shadowColor;

- (UIView*)subviewWithId:(NSString*)LT_id;

@end