//
//  AppDelegate.h
//  FallingStuff2
//

//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
//@property (assign) IBOutlet SKView *skView;
@property (assign) IBOutlet NSView *view;
@property (assign) void * sharedLibraryHandle;

@end
