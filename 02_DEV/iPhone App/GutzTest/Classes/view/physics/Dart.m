//
//  Dart.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.19.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Dart.h"

@implementation Dart

-(id)initAtPos:(CGPoint)pos fires:(int)dir speed:(float)spd {
	if ((self = [super init])) {
		_dir = dir;
		_speed = spd;
		
		_body = [[ChipmunkBody alloc] initWithMass:INFINITY andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:DART_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [Dart class];
		_shape.data = self;

		_sprite = [CCSprite spriteWithFile:@"debug_node-02.png"];
		[_sprite setScale:0.5f];
		[_sprite setPosition:_body.pos];
	}
	
	return (self);
}

-(void)updPos {
	//NSLog(@"Dart.updPos()");
	
	cpVect vecInc;
	
	switch (_dir) {
		case 0:
			vecInc = cpv(_speed, 0);
			break;
		
		case 1:
			vecInc = cpv(0, -_speed);
			break;
			
		case 2:
			vecInc = cpv(-_speed, 0);
			break;
			
		case 3:
			vecInc = cpv(0, _speed);
			break;
	}
	
	_body.pos = cpvadd(_body.pos, vecInc);
	[_sprite setPosition:cpvadd(_body.pos, vecInc)];
}


-(void)dealloc {
	[super dealloc];
}

@end
