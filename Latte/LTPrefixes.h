#ifndef Latte_LTPrefixes_h
#define Latte_LTPrefixes_h

//Latte keywords/tags
static  NSString *const kLTTagIsa           = @"@isa";
static  NSString *const kLTTagStyle         = @"@style";
static  NSString *const kLTTagId            = @"@id";
static  NSString *const kLTTagBind          = @"@bind";
static  NSString *const kLTTagContext       = @"@context-value";
static  NSString *const kLTTagMetric        = @"@metric";
static  NSString *const kLTTagSubviews      = @"@subviews";

//Latte value annotation
static  NSString *const kLTTagSeparator     = @"(";
static  NSString *const kLTTagSeparatorEnd  = @")";
static  NSString *const kLTTagColor         = @"@color";
static  NSString *const kLTTagColorHex      = @"@color-hex";
static  NSString *const kLTTagColorRgb      = @"@color-rgb";
static  NSString *const kLTTagColorPattern  = @"@color-pattern";
static  NSString *const kLTTagColorGradient = @"@color-gradient";
static  NSString *const kLTTagFont          = @"@font";
static  NSString *const kLTTagImage         = @"@image";

//Latte section
static  NSString *const kLTTagLayout        = @"@layout";
static  NSString *const kLTTagStylesheet    = @"@stylesheet";
static  NSString *const kLTTagConstraints   = @"@constraints";

//Stylesheet conventions decorators
static  NSString *const kLTFileSuffixiPhone = @"~iphone";
static  NSString *const kLTFileSuffixiPad   = @"~ipad";

//Debug logs
#define LT_DEBUG

#ifdef LT_DEBUG
#define LTLog(...) NSLog(@"%s %@", __func__, [NSString stringWithFormat:__VA_ARGS__])
#elif
#define LTLog(...) ;
#endif

//imports
#import <JSONKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+LTAdditions.h"
#import "NSString+LTAdditions.h"
#import "UIColor+LTAdditions.h"
#import "UIButton+LTAdditions.h"
#import "UIFont+LTAdditions.h"
#import "NSArray+LTAdditions.h"
#import "NSMutableDictionary+LTAdditions.h"
#import "NSMutableArray+LTAdditions.h"
#import "LTNode.h"
#import "LTParser.h"
#import "LTView.h"
#import "LTWatchFileServer.h"
#import "LTContext.h"
#import "LTLocale.h"
#import "LTAppearance.h"

#endif
