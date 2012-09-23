//
//  LTMenu.m
//  Latte
//
//  Created by Alex Usbergo on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LTMenu.h"
#import "UKKQueue.h"

@interface LTMenu ()
@property (strong) NSStatusItem *statusItem;
@property (assign) BOOL popoverPresented;
@property (strong) NSString *IPAddress;
@end

@implementation LTMenu

static LTMenu *sharedInstace = nil;

#define kStatusSending 1
#define kStatusIdle 2

@synthesize statusItem = _statusItem;
@synthesize menu = _menu;
@synthesize popover = _popover;
@synthesize popoverPresented = _popoverPresented;
@synthesize IPAddress = _IPAddress;

+ (LTMenu*)sharedInstance
{
    return [[LTMenu alloc] init];
}

- (id)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [super init];
    
        [self selectFiles];
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self 
                                                               selector:@selector(fileChanged:) 
                                                                   name:UKFileWatcherWriteNotification 
                                                                 object:nil];
        
        self.IPAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"IPAddress"];
        if (!self.IPAddress) self.IPAddress = @"http://127.0.0.1:9999";
        
    });
    
    return sharedInstace;
}

- (void)selectFiles
{    
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    NSArray *types = [NSArray arrayWithObjects:@"latte", @"lt", @"json", nil];
    
    [openDialog setCanChooseFiles:YES];   
    [openDialog setCanChooseDirectories:NO];
    [openDialog setAllowedFileTypes:types];
    [openDialog setAllowsMultipleSelection:TRUE];
    
    [[UKKQueue sharedFileWatcher] performSelector:@selector(removeAllPathsFromQueue)];
    
    if ([openDialog runModal] == NSOKButton) 
        for (NSURL *url in [openDialog URLs]) {
            [[UKKQueue sharedFileWatcher] addPathToQueue:url.path];
        }
}

- (void)awakeFromNib
{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.highlightMode = YES;    
    [self changeIconForStatus:kStatusIdle];
    
//    NSRect frame = [[_statusItem valueForKey:@"fView"] frame];
//    frame.origin.y -= 1;
//    [[_statusItem valueForKey:@"fView"] setFrame:frame];
    
    [_statusItem setMenu:self.menu];
}

- (void)changeIconForStatus:(NSUInteger)status
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *file = status == kStatusIdle ? @"icon" : @"icon-sel";
    NSString *path = [bundle pathForResource:file ofType:@"png"];
    _statusItem.image = [[NSImage alloc] initWithContentsOfFile:path];
    
    path = [bundle pathForResource:@"icon-inv" ofType:@"png"];
    [_statusItem setAlternateImage:[[NSImage alloc] initWithContentsOfFile:path]];
    
    //set the title (attributed)
    NSString *trimmedIP = [[[[self.IPAddress componentsSeparatedByString:@"//"] objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:0];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:trimmedIP
                                                                attributes:[[NSDictionary alloc] initWithObjectsAndKeys:[NSFont systemFontOfSize:10], NSFontAttributeName,nil]];
    [_statusItem setAttributedTitle:title];
}

- (IBAction)changeIPAddress:(id)sender
{
    //show the popover
    if (!self.popoverPresented) {
        [self changeIconForStatus:kStatusSending];
        [self.popover showRelativeToRect:[[_statusItem valueForKey:@"fView"] bounds] 
                                  ofView:[_statusItem valueForKey:@"fView"] 
                           preferredEdge:NSMaxYEdge];
        
        self.popoverPresented = YES;
        
    //hide the popover
    } else {
        [self changeIconForStatus:kStatusIdle];
        [self.popover close];
        self.popoverPresented = NO;
    }
}

- (IBAction)changeSelectedFiles:(id)sender
{
    [self selectFiles];
}

- (IBAction)applyChangesToIPAddress:(id)sender
{
    NSString *ip1  = [[[sender superview] viewWithTag:1] stringValue];
    NSString *ip2  = [[[sender superview] viewWithTag:2] stringValue];
    NSString *ip3  = [[[sender superview] viewWithTag:3] stringValue];
    NSString *ip4  = [[[sender superview] viewWithTag:4] stringValue];
    NSString *port = [[[sender superview] viewWithTag:5] stringValue];
    
    self.IPAddress = [NSString stringWithFormat:@"http://%@.%@.%@.%@:%@", ip1, ip2, ip3, ip4, port];
    NSLog(@"New IP Address %@", self.IPAddress);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.IPAddress forKey:@"IPAddress"];
	[defaults synchronize];
        
    //hide the popover
    [self changeIconForStatus:kStatusIdle];
    [self.popover close];
    self.popoverPresented = NO;
}

- (IBAction)discardChangesToIPAddress:(id)sender
{
    //hide the popover
    [self changeIconForStatus:kStatusIdle];
    [self.popover close];
    self.popoverPresented = NO;
}

- (IBAction)quit:(id)sender
{
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

/**
 * This is the only method to be implemented to conform to the SCEventListenerProtocol.
 * As this is only an example the event received is simply printed to the console.
 *
 * @param pathwatcher The SCEvents instance that received the event
 * @param event       The actual event
 */
- (void)fileChanged:(NSNotification*)note
{    
    [self changeIconForStatus:kStatusSending];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        [self changeIconForStatus:kStatusIdle];
    });

    
    //the path of the file
    NSString *path = [note.userInfo objectForKey:@"path"];
    NSLog(@"Latte file changed: %@", path);
    
    NSError *error = nil;
    NSString *file = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding 
                                                  error:&error];
    
    //formatting the file
    file = [NSString stringWithFormat:@"PAYLOAD-#%@\n%@", path, file];
    
    //create and send the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.IPAddress]];
    request.HTTPBody = [file dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval = 1.0f;
    
    //no response - acknowledgment    
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"done");
}

@end
