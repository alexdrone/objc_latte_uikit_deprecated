//
//  LTParser+ViewInit.h
//  Latte
//
//  Created by Alex Usbergo on 7/14/12.
//
//

#import "LTParser.h"

@interface LTParser (ViewInit)

/* Tries to parse the primitive latte values such
 * as fonts, color, rects and images */
id LTParsePrimitiveTypes(id object);

/* Initialize the views by reading the Latte dictionary
 * passed as argument */
void LTStaticInitializeViewFromNodeDictionary(UIView *view, NSDictionary *dictionary, NSMutableArray **bindings,
											  NSMutableArray **contextBindings);

@end
