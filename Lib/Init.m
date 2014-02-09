/*
 *  FallingStuff2Lib.cp
 *  FallingStuff2Lib
 *
 *  Created by David Ludwig on 1/6/14.
 *  Copyright (c) 2014 DavidLudwig. All rights reserved.
 *
 */

#import <SpriteKit/SpriteKit.h>
#import "Scene.h"
#include "Init.h"

NSView * CreateScreenSaver(NSRect frame)
{
	SKView * skView = [[SKView alloc] initWithFrame:frame];
    SKScene * scene = [FallingStuffScene sceneWithSize:frame.size];
//    scene.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:scene];
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
	return skView;
}
