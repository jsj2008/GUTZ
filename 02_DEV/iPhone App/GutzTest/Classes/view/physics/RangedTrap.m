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
		
		_shape = [ChipmunkCircleShape circleWithBody:_body radius:TRAP_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [RangedTrap class];
		_shape.data = self;
		
		if (_isVertical) {
			_frame1Sprite = [CCSprite spriteWithFile:@"enemy_spike_f1.png"];
			_frame2Sprite = [CCSprite spriteWithFile:@"enemy_spike_f2.png"];
		} else {
			_frame1Sprite = [CCSprite spriteWithFile:@"furball_f1.png"];
			_frame2Sprite = [CCSprite spriteWithFile:@"furball_f2.png"];
		}
		_frame2Sprite.visible = NO;
		
		_sprite = [CCSprite new];
		[_sprite addChild:_frame1Sprite];
		[_sprite addChild:_frame2Sprite];
		[_sprite setPosition:pos];

		_isDirInc = YES;
		_isFrame1 = YES;
		
		_frameTimer = [NSTimer scheduledTimerWithTimeInterval:TRAP_INTERVAL target:self selector:@selector(onFrameChange:) userInfo:nil repeats:YES];
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

-(void)onFrameChange:(id)sender {
	_isFrame1 = !_isFrame1;
	
	_frame1Sprite.visible = _isFrame1;
	_frame2Sprite.visible = !_isFrame1;
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
	//[_sprite setRotation:_sprite.rotation - 4];
}


@end
