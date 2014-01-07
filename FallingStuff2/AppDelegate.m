//
//  AppDelegate.m
//  FallingStuff2
//
//  Created by David Ludwig on 1/6/14.
//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#import "AppDelegate.h"
#import "../Common/LibLoader.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

	void * sharedLibrary = NULL;
	NSView * view = NULL;
	if (SaverLib_Load([NSBundle mainBundle],
					  @"FallingStuff2Lib.dylib",
					  &sharedLibrary,
					  CGRectMake(0.0, 0.0, 1024.0, 768.0),
					  &view))
	{
		self.sharedLibraryHandle = sharedLibrary;
		[self.view addSubview:view];
	}
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
