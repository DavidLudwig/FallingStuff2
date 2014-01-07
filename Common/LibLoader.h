//
//  LibLoader.h
//  FallingStuff2
//
//  Created by David Ludwig on 1/6/14.
//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#ifndef FallingStuff2_LibLoader_h
#define FallingStuff2_LibLoader_h

#include <dlfcn.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

typedef id (*ViewFactory)(NSRect frame);

static inline BOOL SaverLib_Load(NSBundle * bundle,
								 NSString * libraryName,
								 void ** outLibraryHandle,
								 NSRect viewFrame,
								 NSView ** outView)
{
	void * libraryHandle = NULL;
	ViewFactory viewFactory = NULL;
	NSView * view = NULL;

	// Find the filesystem path to the screen saver's main code, then load it
	// in a way that won't confuse the app's symbol table.
	NSString * libPath = [[bundle sharedFrameworksPath] stringByAppendingPathComponent:libraryName];
	libraryHandle = dlopen([libPath UTF8String], RTLD_LOCAL);
	if ( ! libraryHandle) {
		NSLog(@"dlopen failed: %s", dlerror());
		return NO;
	}

	// Create the screen saver's NSView:
	viewFactory = (ViewFactory) dlsym(libraryHandle, "CreateScreenSaver");
	if ( ! viewFactory) {
		NSLog(@"dlsym failed for 'CreateScreenSaver': %s", dlerror());
		dlclose(libraryHandle);
		return NO;
	}
	
	view = viewFactory(viewFrame);
	if ( ! view) {
		NSLog(@"CreateScreenSaver failed");
		dlclose(libraryHandle);
		return NO;
	}
	
	*outLibraryHandle = libraryHandle;
	*outView = view;
	return YES;
}

#endif
