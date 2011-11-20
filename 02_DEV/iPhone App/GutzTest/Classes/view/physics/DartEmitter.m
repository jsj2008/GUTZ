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
		
		_sprite = [CCSprite spriteWithFile:@"debug_node-01.png"];
		[_sprite setPosition:pos];
		[_sprite setRotation:90 * type];
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
		
		arrDarts = [[NSMutableArray alloc] init];
		_isFiring = NO;
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
	
	Dart *dart = [[Dart alloc] initAtPos:_body.pos fires:interval speed:speed];
	[arrDarts addObject:dart];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FIRE_DART" object:dart];
	
	//[_space add:dart];
	//[_layer addChild:dart._sprite];
}

-(void)updDarts {
	//NSLog(@"DartEmitter.updDarts()");
	
	for (Dart *dart in arrDarts)
		[dart updPos];
}

-(void)dealloc {
	[_sprite release];
	[super dealloc];
}


@end
