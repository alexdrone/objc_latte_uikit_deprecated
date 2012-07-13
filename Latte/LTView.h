//
//  LTView.h
//  Latte
//
//  Created by Alex Usbergo on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTContext.h"
@class LTContext;

@interface LTView : UIView {
    @private
    id _object;
    LTContext *_context;
}

/* The data objects */

@property (strong) NSString *filename;


/* Constructs a new latte view.
 * If the debug flag is enabled, the view is registered in 
 * the watch file service.
 * The filename parameter points to the markup file with the 
 * view definition. (markup file's parse structure are cached)*/
- (id)initWithLatteFile:(NSString*)filename;

/* Recreates the entire view hierarchy from the markup 
 * file passed as argument. */
- (void)loadViewFromLatteFile:(NSString*)filename;

/* Render all the textual templates with the new object associated to the view.
 * Moreover it subscribes the view to object's properties changes. (for they keypaths that
 * are marked with the @bind keyword */
- (void)refreshView;

/* Bind the given object to this view.
 * See the guide for more information about it. */
- (void)bind:(id)object;
- (void)bind:(id)object withContext:(void (^)(LTContext *context, id object))contextSetup;


@end
