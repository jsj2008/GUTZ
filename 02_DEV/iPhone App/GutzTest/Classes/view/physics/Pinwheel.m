//
//  Pinwheel.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.20.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Pinwheel.h"

@implementation Pinwheel

-(id)initAtPos:(CGPoint)pos spinsClockwise:(BOOL)spins speed:(float)spd {
	if ((self = [super init])) {
		_isClockwise = spins;
		_speed = spd;
		_ptPos = pos;
		
		//set = [NSMutableSet set];
		//chipmunkObjects = set;
		
		
		
		
		
		_body = [[ChipmunkBody alloc] initWithMass:INFINITY andMoment:INFINITY];
		_body.pos = pos;
		//[set addObject:_body];
		
		_shape = [ChipmunkPolyShape boxWithBody:_body width:50 height:4];
		//_shape = [ChipmunkCircleShape circleWithBody:_body radius:16.0f offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [Pinwheel class];
		_shape.data = self;
		//[set addObject:_shape];
		
		/*
		ChipmunkCircleShape *lShape = [ChipmunkCircleShape circleWithBody:_body radius:16 offset:cpv(-34, 0)];
		lShape.elasticity = 0.0f;
		lShape.friction = 0.0f;		
		lShape.collisionType = [Pinwheel class];
		lShape.data = self;
		
		ChipmunkCircleShape *rShape = [ChipmunkCircleShape circleWithBody:_body radius:16 offset:cpv(34, 0)];
		rShape.elasticity = 0.0f;
		rShape.friction = 0.0f;		
		rShape.collisionType = [Pinwheel class];
		rShape.data = self;
		*/
		
		_sprite = [CCSprite spriteWithFile:@"handwheel.png"];
		[_sprite setPosition:_body.pos];
		
		if (!_isClockwise)
			_speed = -_speed;
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}


-(void)attach:(ChipmunkSpace *)space {
	
	ChipmunkBody *anchorBody = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
	anchorBody.pos = cpvadd(_ptPos, cpv(0, 64));
	[space add:anchorBody];
	
	ChipmunkStaticCircleShape *anchorShape = [ChipmunkStaticCircleShape circleWithBody:anchorBody radius:8 offset:cpvzero];
	[space add:anchorShape];
	
	//ChipmunkConstraint *pinJoint = [ChipmunkPinJoint pinJointWithBodyA:anchorBody bodyB:_body anchr1:cpvzero anchr2:cpvzero];
	//[space add:pinJoint];
	
	//ChipmunkConstraint *motor = [ChipmunkSimpleMotor simpleMotorWithBodyA:_body bodyB:space.staticBody rate:CC_DEGREES_TO_RADIANS(_speed)];
	//[space add:motor];
}


-(void)updRot {
	[_sprite setRotation:_sprite.rotation += _speed];
}

@end
