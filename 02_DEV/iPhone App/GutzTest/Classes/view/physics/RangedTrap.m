//
//  RangedTrap.m
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RangedTrap.h"

@implementation RangedTrap


-(id)initAtPos:(CGPoint)pos vertical:(BOOL)vert speed:(float)spd range:(CGPoint)rng {
	if ((self = [super init])) {
		
		_isVertical = vert;
		_speed = spd;
		_range = rng;
		
		_body = [[ChipmunkBody alloc] initWithMass:INFINITY andMoment:INFINITY];
		_body.pos = pos;
		
		if (_isVertical)
			_shape = [ChipmunkPolyShape boxWithBody:_body width:TRAP_HEIGHT height:TRAP_WIDTH];
		
		else
			_shape = [ChipmunkPolyShape boxWithBody:_body width:TRAP_WIDTH height:TRAP_HEIGHT];
		
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [RangedTrap class];
		_shape.data = self;
		
		_sprite = [CCSprite spriteWithFile:@"debug_node-01.png"];
		[_sprite setPosition:pos];
		
		if (_isVertical) {
			[_sprite setScaleX:2.0f];
			[_sprite setScaleY:7.0f];
			
		} else {
			[_sprite setScaleX:7.0f];
			[_sprite setScaleY:2.0f];
		}
		
		_isDirInc = YES;
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	
	return (self);
	
}

-(void)updateCovered:(BOOL)covered {
	isCovered = covered;
	
	if ([self isCovered])
		[_sprite setOpacity:128];
	
	else
		[_sprite setOpacity:255];
}


-(void)dealloc {
	[super dealloc];
}

-(void)updPos {
	cpVect vecInc;
	
	if (_isVertical) {
		if (_sprite.position.y > _range.y)
			_isDirInc = NO;
		
		else if (_sprite.position.y < _range.x)
			_isDirInc = YES;
		
		
		if (_isDirInc)
			vecInc = cpv(0, _speed);
		
		else
			vecInc = cpv(0, -_speed);
		
	} else {
		if (_sprite.position.x < _range.x)
			_isDirInc = YES;
	
		else if (_sprite.position.x > _range.y)
			_isDirInc = NO;
	
	
		if (_isDirInc)
			vecInc = cpv(_speed, 0);
	
		else
			vecInc = cpv(-_speed, 0);
	}
	
	_body.pos = cpvadd(_body.pos, vecInc);
	[_sprite setPosition:cpvadd(_body.pos, vecInc)];

}


@end
