//
//  SharedLibLoader.c
//  FallingStuff2
//
//  Created by David Ludwig on 1/6/14.
//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#include <dlfcn.h>

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "SaverLibWrapper.h"

//typedef id (*ViewFactory)(NSRect frame);
//
//@interface SaverLibWrapper()
//@property (assign) void * libraryHandle;
//@property (assign) ViewFactory viewFactory;
//- (id) initWithBundle:(NSBundle *)bundle;
//@end
//
//@implementation SaverLibWrapper
//
//+ (SaverLibWrapper *) libraryFromBundle:(NSBundle *)bundle
//{
//	return [[SaverLibWrapper alloc] initWithBundle:bundle];
//}
//
//- (id) initWithBundle:(NSBundle *)bundle
//{
//	self = [super init];
//	if (self) {
//		NSString * libPath = [[bundle sharedFrameworksPath] stringByAppendingPathComponent:@"FallingStuff2Lib.dylib"];
//		self.libraryHandle = dlopen([libPath UTF8String], RTLD_LOCAL);
//		if ( ! self.libraryHandle) {
//			NSLog(@"dlopen failed: %s", dlerror());
//			return nil;
//		}
//		
//		self.viewFactory = dlsym(self.libraryHandle, "CreateScreenSaver");
//		if ( ! self.viewFactory) {
//			NSLog(@"dlsym failed for 'CreateScreenSaver': %s", dlerror());
//			return nil;
//		}
//		
//	}
//	return self;
//}
//
//- (void) dealloc
//{
//	if (self.libraryHandle) {
//		dlclose(self.libraryHandle);
//		self.libraryHandle = NULL;
//	}
//}
//
//- (NSView *) createViewWithFrame:(NSRect)frame
//{
//	if (self.viewFactory) {
//		return self.viewFactory(frame);
//	} else {
//		return nil;
//	}
//}
//
//@end
