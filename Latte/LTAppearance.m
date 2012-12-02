//
//  LTAppearance.m
//  Latte
//
//  Created by Alex Usbergo on 9/17/12.
//
//

#import "LTPrefixes.h"

@interface LTAppearance ()

/* Keep tracks of where the different styles where declared
 * in order to roll the back when necessary */
@property (nonatomic, strong) NSMutableDictionary *stylesForFilename;

@end


@implementation LTAppearance

#pragma mark - Init

+ (LTAppearance*)sharedInstance
{
    static dispatch_once_t pred;
    static LTAppearance *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[LTAppearance alloc] init];
    });
    
    return shared;
}

/* LTAppearance is the unique entrypoint for all the 
 * stylesheet values and for other UI-related constants */
- (id)init
{
    if (self = [super init]) {
		
		self.stylesheet = [[NSMutableDictionary alloc] init];
		self.stylesForFilename = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - Stylesheet logic

/* Add to the current stylesheet the values read from
 * the stylesheet file */
- (void)readStylesheetNamed:(NSString*)filename
{	
    NSError *error = nil;
    
    NSString *extension = [LTParser sharedInstance].useJSONMarkup ? @"json" : @"latte";
    NSString *input = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:extension]
												encoding:NSUTF8StringEncoding
												   error:&error];
	if (nil != error || nil == input) {
		LTLog(@"Unable to read the file %@", filename);
		return;
	}
	
    NSMutableDictionary *json = [filename mutableObjectFromJSONStringWithParseOptions:JKParseOptionComments|JKParseOptionPermitTextAfterValidJSON];
	
	if (nil == json)
		LTLog(@"Unable to parse the json");
	
	[self setStylesheet:json forKey:filename];
}

/* Manually set the given JSON dictionary of style
 * for the given filename. The filename is important
 * in order to be able to replace it real-time if the content
 * changes (via LTWatchFileServer) */
- (void)setStylesheet:(NSMutableDictionary*)json forKey:(NSString*)filename
{
	json = json[kLTTagStylesheet];
	
	if (nil == json) {
		LTLog(@"No @stylesheet section defined");
		return;
	}
	
	//Remove the old key
	for (NSString *key in self.stylesForFilename[filename])
		if (nil != self.stylesheet[key])
			[self.stylesheet removeObjectForKey:key];
	

	self.stylesForFilename[filename] = json.allKeys;
	
	
}

#pragma mark - Appearance constants

- (NSNumber*)screenWidth
{
	return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation]) ?
	@([UIScreen mainScreen].applicationFrame.size.width) :
	@([UIScreen mainScreen].applicationFrame.size.height);
}

- (NSNumber*)screenHeight
{
	return UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation]) ?
	@([UIScreen mainScreen].applicationFrame.size.height) :
	@([UIScreen mainScreen].applicationFrame.size.width);
}

- (NSNumber*)isPad
{
	return @(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSNumber*)isPhone
{
	return @(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

@end
