//
//  UIView+LTAdditions.h
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTView;

@interface LTBind : UIView

@property (strong) NSString *bind;

@end

@interface UIView (LTAdditions)

@property (strong) NSString *LT_id;
@property (strong) NSString *LT_style;
@property (strong) LTView *LT_container;

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
@property (readonly) NSNumber *maxX;
@property (readonly) NSNumber *maxY;

/* CALayer properties wrapper*/
@property (strong) NSNumber *cornerRadius;
@property (strong) NSNumber *borderWidth;
@property (strong) UIColor *borderColor;
@property (strong) NSNumber *shadowOpacity;
@property (strong) NSNumber *shadowRadius;
@property (strong) NSArray *shadowOffset;
@property (strong) UIColor *shadowColor;

/* autoresizing mask from string array */
@property (strong) NSArray *autoresizingMaskOptions;

/* Recursively searches and returns the view with the given @id */
- (UIView*)LT_subviewWithId:(NSString*)LT_id;

/* Applies the latte style defined in in the
 * @stylesheet section to the current view */
- (void)LT_applyStyle:(NSString*)style;

/* Redirect to the wrapping object key, for example
 * autoresingMask is redirected to autoresizingMaskOptions */
+ (NSString*)LT_wrappingKeyForKey:(NSString*)key;

@end