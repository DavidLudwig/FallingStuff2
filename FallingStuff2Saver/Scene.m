//
//  FallingStuffScene.m
//  FallingStuff2
//
//  Created by David Ludwig on 1/6/14.
//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#import "Scene.h"

@implementation FallingStuffScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    }
    return self;
}

@end
