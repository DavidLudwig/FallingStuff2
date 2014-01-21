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
	if (min == max) {
		return min;
	}
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



// Physics Body Categories
static const uint32_t wallCategory		= 0x1 << 0;
static const uint32_t pegCategory		= 0x1 << 1;
static const uint32_t ballCategory		= 0x1 << 2;


@interface FallingStuffScene()
@property (strong) NSDictionary * config;
@property (weak) NSTimer * flashFixTimer;
@property (assign) int ballCount;
@end

@implementation FallingStuffScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.config = @{
			@"background-color": [SKColor blackColor],
			@"ball-background-alpha": @0.5,
			@"ball-background-colors": @[
				[SKColor colorWithCalibratedRed:0.827 green:0.741 blue:0.549 alpha:1.0],	// "#d3bd8c" --> 211, 189, 140 --> 0.827, 0.741, 0.549
			],
			@"ball-count-max": @100,
			@"ball-dimension-begin": @20,
			@"ball-dimension-end": @35,
			@"ball-spawn-delay-begin": @0.1,
			@"ball-spawn-delay-end": @0.5,
			@"peg-count-begin": @9,
			@"peg-count-end": @15,
			@"peg-dimension-scale-begin": @0.1,
			@"peg-dimension-scale-end": @0.35,
			@"peg-background-alpha": @0.5,
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
			@"scene-post-completion-refresh-delay": @15.0,
		};
		
		srand((unsigned int)time(NULL));
		
		self.backgroundColor = C_OBJ("background-color");

		// HACK: work-around a possible bug in OSX whereby the screensaver will
		// refresh twice on the screensaver's first display.
		NSTimer * timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(refresh) userInfo:nil repeats:NO];
		self.flashFixTimer = timer;
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)dealloc
{
	[self stopFlashFixTimer];
}

- (void)stopFlashFixTimer
{
	if (self.flashFixTimer) {
		if ([self.flashFixTimer isValid]) {
			[self.flashFixTimer invalidate];
		}
		self.flashFixTimer = nil;
	}
}

- (void)refresh
{
	// Clean-up previous things and reset the physics world:
	[self stopFlashFixTimer];
	[self removeAllChildren];
	self.physicsWorld.gravity = CGVectorMake(0.0, -1.0);
	self.ballCount = 0;
	
	// Set-up new things:
	[self addWalls];
	[self addPegs];
	
	// Tick once:
	[self tick];
}

- (void)tick
{
	if (self.ballCount < C_INT("ball-count-max")) {
		[self addBall];
		if (self.ballCount < C_INT("ball-count-max")) {
			const NSTimeInterval delay = RandFloat(C_RANGE_FLOAT("ball-spawn-delay"));
			[self performSelector:@selector(tick) withObject:self afterDelay:delay];
			return;
		}
	}
	
	[self performSelector:@selector(refresh) withObject:self afterDelay:C_FLOAT("scene-post-completion-refresh-delay")];
}

- (void)addWalls
{
	CGRect frame = self.frame;
	frame.size.height *= 2.0;	// balls spawn above the visible screen... extend the walls appropriately
	self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
	self.physicsBody.categoryBitMask = wallCategory;
}

- (void)addPegs
{
	const CGFloat scaleBase = MIN(self.size.width, self.size.height);

	const int numPegs = RandInt(C_RANGE_INT("peg-count"));
	for (int i = 0; i < numPegs; ++i) {
		// Calculate the peg's bounds:
		CGFloat cx = RandFloat(0.0, self.size.width);
		CGFloat cy = RandFloat(0.0, self.size.height);
		CGFloat dimension = scaleBase * RandFloat(C_RANGE_FLOAT("peg-dimension-scale"));
		CGRect rect = CGRectCentered(0.0, 0.0, dimension, dimension);

		// Create a peg:
		SKShapeNode * peg = [[SKShapeNode alloc] init];
		peg.path = CGPathCreateWithEllipseInRect(rect, NULL);
		peg.position = CGPointMake(cx - (rect.size.width / 2.0), cy - (rect.size.height / 2.0));
		peg.fillColor = [(SKColor *)RandArrayElement(C_OBJ("peg-background-colors")) colorWithAlphaComponent:C_FLOAT("peg-background-alpha")];
		peg.strokeColor = [peg.fillColor colorWithAlphaComponent:1.0];
		peg.glowWidth = 0.0;
		peg.lineWidth = 1.0;
		peg.antialiased = NO;
		peg.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(dimension / 2.0)];
		peg.physicsBody.dynamic = NO;
		peg.physicsBody.categoryBitMask = pegCategory;
		[self addChild:peg];
	}
}

- (void)addBall
{
	CGFloat cx = RandFloat(0.0, self.size.width);
	CGFloat cy = self.frame.size.height * 1.5;
	CGFloat dimension = RandFloat(C_RANGE_FLOAT("ball-dimension"));
	CGRect rect = CGRectCentered(0.0, 0.0, dimension, dimension);

	SKShapeNode * ball = [[SKShapeNode alloc] init];
	ball.path = CGPathCreateWithEllipseInRect(rect, NULL);
	ball.position = CGPointMake(cx - (rect.size.width / 2.0), cy - (rect.size.height / 2.0));
	ball.fillColor = [(SKColor *)RandArrayElement(C_OBJ("ball-background-colors")) colorWithAlphaComponent:C_FLOAT("ball-background-alpha")];
	ball.strokeColor = [ball.fillColor colorWithAlphaComponent:1.0];
	ball.glowWidth = 0.0;
	ball.lineWidth = 1.0;
	ball.antialiased = NO;
	ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(dimension / 2.0)];
	ball.physicsBody.dynamic = YES;
	ball.physicsBody.categoryBitMask = ballCategory;
	ball.physicsBody.collisionBitMask = ballCategory | pegCategory | wallCategory;
	[self addChild:ball];
	
	self.ballCount += 1;
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
