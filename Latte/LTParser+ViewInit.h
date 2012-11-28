//
//  LTParser+ViewInit.h
//  Latte
//
//  Created by Alex Usbergo on 7/14/12.
//
//

#import "LTParser.h"

NS_ENUM(NSUInteger, LTParsePrimitiveTypeOption) {
	LTParsePrimitiveTypeOptionOptimal,
	LTParsePrimitiveTypeOptionNone
};

@interface LTParser (ViewInit)

/* Tries to parse the primitive latte values such
 * as fonts, color, rects and images. */
id LTParsePrimitiveType(id object, enum LTParsePrimitiveTypeOption option);

/* Initialize the views by reading the Latte dictionary
 * passed as argument */
void LTStaticInitializeViewFromNodeDictionary(UIView *view, NSDictionary *dictionary, NSMutableArray **bindings,
											  NSMutableArray **contextBindings);

@end
