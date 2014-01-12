//
//  FallingStuff2SaverView.m
//  FallingStuff2Saver
//
//  Created by David Ludwig on 1/6/14.
//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#include <dlfcn.h>

#import "SaverView.h"
#import "../Common/LibLoader.h"


typedef id (*ScreenSaverFactory)(NSRect frame);

@implementation FallingStuff2SaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/60.0];
		
		void * sharedLibrary = NULL;
		NSView * view = NULL;
		if (SaverLib_Load([NSBundle bundleForClass:[self class]],
						  @"FallingStuff2Lib.dylib",
						  &sharedLibrary,
						  CGRectMake(0.0, 0.0, frame.size.width, frame.size.height),
						  &view))
		{
			self.sharedLibraryHandle = sharedLibrary;
			[self addSubview:view];
			self.mainView = view;
		}
    }
    return self;
}

- (void)dealloc
{
	if (self.sharedLibraryHandle) {
		dlclose(self.sharedLibraryHandle);
		self.sharedLibraryHandle = NULL;
	}
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
