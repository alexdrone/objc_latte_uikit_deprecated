//
//  LTMarkupInjector.m
//  Latte
//
//  Created by Alex Usbergo on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LTWatchFileServer.h"
#import "LTPrefixes.h"
#import "AsyncSocket.h"

#define kLTPayloadSeparator @"//payload"

@interface LTWatchFileServer ()

@property (strong) NSMutableDictionary *observers;
@property (strong) NSMutableArray *clients;
@property (strong) AsyncSocket *socket;
@property (assign, atomic, getter = isRunning) BOOL running;

@end

@implementation LTWatchFileServer

#pragma mark Singleton initialization code

+ (LTWatchFileServer*)sharedInstance
{
    static dispatch_once_t pred;
    static LTWatchFileServer *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[LTWatchFileServer alloc] init];
    });
    
    return shared;
}

- (id)init
{
    if (self = [super init]) {
        _observers = [[NSMutableDictionary alloc] init];
        _clients = [[NSMutableArray alloc] init];
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
        _running = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [self stop];
}

#pragma mark Socket

/* Start the guard manager on the given port */
- (void)startOnPort:(NSUInteger)port 
{
    //the server is already running
    if ([self isRunning]) return;
 
    if (port > 65535) port = 0;
        
    NSError *err = nil;
    if (NO == [_socket acceptOnPort:port error:&err]) {
        NSLog(@"Can't open the socket - %@", err);
        return;
    }
    
    self.running = YES;
}

- (void)stop
{
    if (NO == [self isRunning]) return;

    [self.socket disconnect];

    for (AsyncSocket *c in self.clients)
        [c disconnect];

    self.running = NO;
}

#pragma mark Register/Deregister observers

- (void)registerView:(LTView*)view
{
    //unable to register a view that is not linked to a file
    if (nil == view.filename) return;
    
    NSMutableArray *views = self.observers[view.filename];
    if (nil == views) 
        views = [[NSMutableArray alloc] init];
    
    [views addObject:view];
    self.observers[view.filename] = views;
}

- (void)deregisterView:(LTView*)view
{
    //unable to deregister a view that is not linked to a file
    if (nil == view.filename) return;
    
    NSMutableArray *views = self.observers [view.filename];
    [views removeObject:view];
}

#pragma mark Delegate

- (void)onSocket:(AsyncSocket *)socket didAcceptNewSocket:(AsyncSocket*)newSocket 
{
	[self.clients addObject:newSocket];
}

- (void)onSocketDidDisconnect:(AsyncSocket*)socket 
{
	[self.clients removeObject:socket];
}

- (void)onSocket:(AsyncSocket*)socket didConnectToHost:(NSString*)host port:(UInt16)port;
{
    [socket readDataWithTimeout:-1 tag:0];
}

/* Triggered when guard.js send some markup data.
 * All the views are refreshed with the new markup */
- (void)onSocket:(AsyncSocket*)socket didReadData:(NSData*)data withTag:(long)tag 
{
    //ackwoledgement
    [socket writeData:[@"HTTP/1.1 200" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    @try {
                
        //the view name is set in the first line of the markup file
        //rawdata (for compatibilitiy with the old node.js client)
        NSString *latte = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByString:kLTPayloadSeparator][1];
        NSString *filename = [latte componentsSeparatedByString:@"\n"][0];
        
        //remove the pathname
        filename = [[filename componentsSeparatedByString:@"/"] lastObject];
        
        //remove the suffix from the file if specified
        if ([filename hasSuffix:@".json"])
            filename = [filename stringByReplacingOccurrencesOfString:@".json" withString:@""];
	    
        [[LTParser sharedInstance] replaceCacheForFile:filename 
                                              withNode:[[LTParser sharedInstance] parseMarkup:latte]];
                
        for (LTView *v in self.observers[filename])
            [v loadViewFromLatteFile:filename];
    }
    
    @catch (NSException *exception) {
        NSLog(@"Corrupted request");
    }
}


@end
