//
//  FallingStuff2SaverView.h
//  FallingStuff2Saver
//
//  Created by David Ludwig on 1/6/14.
//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface FallingStuff2SaverView : ScreenSaverView

@property (assign) void * sharedLibraryHandle;
@property (weak) NSView * mainView;

@end
