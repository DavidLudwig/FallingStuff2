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
	CGRect saverSize = self.view.frame;
	saverSize.origin = CGPointMake(0.0, 0.0);

	void * sharedLibrary = NULL;
	NSView * view = NULL;
	if (SaverLib_Load([NSBundle mainBundle],
					  @"FallingStuff2Lib.dylib",
					  &sharedLibrary,
					  saverSize,
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
