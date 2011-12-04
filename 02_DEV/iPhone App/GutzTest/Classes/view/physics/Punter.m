//
//  Punter.m
//  GutzTest
//
//  Created by Matthew Holcombe on 12.01.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Punter.h"

@implementation Punter

-(id)initAtPos:(cpVect)pos interval:(int)itv force:(float)str {
	if ((self = [super init])) {
		
		_interval = itv;
		_force = str;
		_ptPos = pos;
		
		_body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		_body.pos = cpvadd(pos, cpv(0, 12));
		
		_sprite = [CCSprite spriteWithFile:@"punter_f1.png"];
		[_sprite setPosition:pos];
		
		_shape = [ChipmunkPolyShape boxWithBody:_body width:48 height:12];
		_shape.friction = 1.0;
		_shape.elasticity = 0.0;
		_shape.collisionType = [Punter class];
		_shape.data = self;
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}


-(void)toggle:(BOOL)isActive {
	
	_isActive = isActive;
	
	if (_isActive)
		_timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(fire:) userInfo:nil repeats:YES];
	
	else {
		[_timer invalidate];
		_timer = nil;
	}
}


-(void)updPos {
	if (_sprite.position.y > _ptPos.y + 111)
		_isDirInc = NO;
	
	else if (_sprite.position.y < _ptPos.y)
		_isDirInc = YES;
	
	cpVect vecInc;
	if (_isDirInc)
		vecInc = cpv(0, _force);
	
	else
		vecInc = cpv(0, -_force);
	
	[_body setPos:cpvadd(_body.pos, vecInc)];
	[_sprite setPosition:cpvadd(_body.pos, vecInc)];
}

-(void)fire:(id)sender {
	
}




-(void)dealloc {
	[super dealloc];
}


@end
