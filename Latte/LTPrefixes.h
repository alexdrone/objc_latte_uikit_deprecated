#ifndef Latte_LTPrefixes_h
#define Latte_LTPrefixes_h


//Latte keywords/tags
#define kLTTagIsa           @"@isa"
#define kLTTagStyle         @"@style"
#define kLTTagId            @"@id"
#define kLTTagBind          @"@bind"
#define kLTTagContext       @"@context-value"
#define kLTTagSubviews      @"@subviews"

//Latte value annotation
#define kLTTagSeparator     @":"
#define kLTTagColor         @"@color"
#define kLTTagColorHex      @"@color-hex"
#define kLTTagColorRgb      @"@color-rgb"
#define kLTTagColorPattern  @"@color-pattern"
#define kLTTagFont          @"@font"
#define kLTTagImage         @"@image"

//Latte section
#define kLTTagLayout        @"@layout"
#define kLTTagStylesheet    @"@stylesheet"
#define kLTTagConstraints   @"@constraints"

//imports
#import <JSONKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+LTAdditions.h"
#import "NSString+LTAdditions.h"
#import "LTNode.h"
#import "LTParser.h"
#import "LTView.h"
#import "LTWatchFileServer.h"
#import "LTContext.h"
#import "LTLocale.h"
#import "LTParser+ViewInit.h"
#import "LTAppearance.h"

#endif
