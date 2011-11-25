//
//  DartEmitter.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.19.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DartEmitter.h"

@implementation DartEmitter

@synthesize ind;
@synthesize arrDarts;

-(id)initAtPos:(CGPoint)pos fires:(int)dir freq:(float)itv speed:(float)spd {
	if ((self = [super init])) {
		NSLog(@"[DartEmitter initAtPos:(%f, %f) fires:(%d) freq:(%f) speed:(%f)", pos.x, pos.y, dir, itv, spd);
		
		type = dir;
		interval = itv;
		speed = spd;
		
		_body = [[ChipmunkBody alloc] initWithMass:INFINITY andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:EMITTER_WIDTH height:EMITTER_HEIGHT];
		
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [DartEmitter class];
		_shape.data = self;
		
		_sprite = [CCSprite spriteWithFile:@"dartEmitter.png"];
		[_sprite setPosition:cpvadd(pos, cpv(EMITTER_WIDTH * 0.5f, 0))];
		[_sprite setRotation:90 * type];
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
		
		arrDarts = [[NSMutableArray alloc] init];
		_isFiring = NO;
		
		CCSprite *fire1Sprite = [CCSprite spriteWithFile:@"dartEmitter.png"];
		[fire1Sprite setPosition:cpvadd(pos, cpv(EMITTER_WIDTH * 0.36f, 0))];
		[fire1Sprite setRotation:90 * type];
		[fire1Sprite setScaleX:0.72f];
		
		CCSprite *fire2Sprite = [CCSprite spriteWithFile:@"dartEmitter.png"];
		[fire2Sprite setPosition:cpvadd(pos, cpv(EMITTER_WIDTH * 0.725f, 0))];
		[fire2Sprite setRotation:90 * type];
		[fire2Sprite setScaleX:0.32f];
		
		CCSprite *fire3Sprite = [CCSprite spriteWithFile:@"dartEmitter.png"];
		[fire3Sprite setPosition:cpvadd(pos, cpv(EMITTER_WIDTH * 1.45f, 0))];
		[fire3Sprite setRotation:90 * type];
		[fire3Sprite setScaleX:1.45f];
		
		arrFrames = [[NSArray alloc] initWithObjects:fire1Sprite, fire2Sprite, fire3Sprite, nil];
	}
	
	return (self);
}

-(void)toggleFiring:(BOOL)isFiring {
	
	_isFiring = isFiring;
	
	if (_isFiring)
		_fireTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(fire:) userInfo:nil repeats:YES];
	
	else {
		[_fireTimer invalidate];
		_fireTimer = nil;
	}
}

-(void)fire:(id)sender {
	//NSLog(@"DartEmitter.fire()");
	
	Dart *dart = [[Dart alloc] initAtPos:cpvadd(_body.pos, cpv(EMITTER_WIDTH + 10, 0)) fires:type speed:speed];
	[arrDarts addObject:dart];
	
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"FIRE_DART" object:dart];
	
	[_space add:dart];
	[_layer addChild:dart._sprite];
}

-(void)updDarts {
	//NSLog(@"DartEmitter.updDarts()");
	
	for (Dart *dart in arrDarts)
		[dart updPos];
}

-(void)flush {
	for (Dart *dart in arrDarts) {
		[_layer removeChild:dart._sprite cleanup:NO];
		[_space remove:dart];
	}
}

-(void)dealloc {
	[_sprite release];
	[super dealloc];
}


@end
