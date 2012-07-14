//
//  LTParser+ViewInit.h
//  Latte
//
//  Created by Alex Usbergo on 7/14/12.
//
//

#import "LTParser.h"

@interface LTParser (ViewInit)

/* Initialize the views by reading the Latte dictionary
 * passed as argument */
void LTStaticInitializeViewFromNodeDictionary(UIView *view, NSDictionary *dictionary, NSMutableArray **bindings,
                                              NSMutableArray **contextBindings);

@end
