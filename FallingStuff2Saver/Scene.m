//
//  FallingStuffScene.m
//  FallingStuff2
//
//  Created by David Ludwig on 1/6/14.
//  Copyright (c) 2014 DavidLudwig. All rights reserved.
//

#import <Carbon/Carbon.h>	// ... for [NSEvent keyCode] codes
#import "Scene.h"

#define C_OBJ(NAME)				self.config[@ NAME]
#define C_FLOAT(NAME)			[self.config[@ NAME] floatValue]
#define C_INT(NAME)				[self.config[@ NAME] intValue]
#define C_RANGE_INT(NAME)		C_INT(NAME "-begin"), C_INT(NAME "-end")
#define C_RANGE_FLOAT(NAME)		C_FLOAT(NAME "-begin"), C_FLOAT(NAME "-end")

#if 0
#define LOG(...) NSLog(__VA_ARGS__)
#else
#define LOG(...)
#endif

@interface FallingStuffScene()
@property (strong) NSDictionary * config;
@end

float RandFloat(float rangeBegin, float rangeEnd)
{
	const float min = MIN(rangeBegin, rangeEnd);
	const float max = MAX(rangeBegin, rangeEnd);
	const float r = (float)rand() / (float)RAND_MAX;
	return min + (r * (max - min));
}

int RandInt(int rangeBegin, int rangeEnd)
{
	const int min = MIN(rangeBegin, rangeEnd);
	const int max = MAX(rangeBegin, rangeEnd);
	return min + (rand() % (max - min));
}

id RandArrayElement(NSArray * src)
{
	if ([src count] == 0) {
		return nil;
	}
	const int i = (rand() % [src count]);
	return [src objectAtIndex:i];
}

static CGRect CGRectCentered(CGFloat cx, CGFloat cy, CGFloat width, CGFloat height)
{
	CGRect r;
	r.origin.x = cx - (width / 2.0);
	r.origin.y = cy - (height / 2.0);
	r.size.width = width;
	r.size.height = height;
	return r;
}


@implementation FallingStuffScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.config = @{
			@"background-color": [SKColor blackColor],
			@"peg-count-begin": @9,
			@"peg-count-end": @15,
			@"peg-dimension-scale-begin": @0.1,
			@"peg-dimension-scale-end": @0.35,
			@"peg-background-colors": @[
				[SKColor redColor],		// red
				[SKColor redColor],		// red
				[SKColor greenColor],	// green
				[SKColor greenColor],	// green
				[SKColor blueColor],	// blue
				[SKColor blueColor],	// blue
				[SKColor yellowColor],	// yellow
				[SKColor colorWithCalibratedRed:0 green:1 blue:1 alpha:1],	// turquoise
			],
			@"peg-background-alpha": @0.5,
		};
		
		self.backgroundColor = C_OBJ("background-color");

		[self refresh];
    }
    return self;
}

- (void)refresh
{
	[self removeAllChildren];
	[self populatePegs];
}

- (void)populatePegs
{
	const CGFloat scaleBase = MIN(self.size.width, self.size.height);

	const int numPegs = RandInt(C_RANGE_INT("peg-count"));
	for (int i = 0; i < numPegs; ++i) {
		// Calculate the peg's bounds:
		CGFloat cx = RandFloat(0.0, self.size.width);
		CGFloat cy = RandFloat(0.0, self.size.height);
		CGFloat dimension = scaleBase * RandFloat(C_RANGE_FLOAT("peg-dimension-scale"));
		CGRect rect = CGRectCentered(cx, cy, dimension, dimension);

		// Create a peg:
		SKShapeNode * peg = [[SKShapeNode alloc] init];
		peg.path = CGPathCreateWithEllipseInRect(rect, NULL);
		peg.fillColor = [(SKColor *)RandArrayElement(C_OBJ("peg-background-colors")) colorWithAlphaComponent:C_FLOAT("peg-background-alpha")];
		peg.strokeColor = [SKColor whiteColor];
		peg.glowWidth = 0.0;
		[self addChild:peg];
	}
}

- (void)keyDown:(NSEvent *)theEvent
{
	switch ([theEvent keyCode]) {
		case kVK_ANSI_R:
			[self refresh];
			break;
		default:
			return [super keyDown:theEvent];
	}
}

@end
