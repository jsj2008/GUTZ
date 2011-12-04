//
//  BombTarget.m
//  GutzTest
//
//  Created by Matthew Holcombe on 12.01.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BombTarget.h"

@implementation BombTarget
-(id)initAtPos:(CGPoint)pos {
	if ((self = [super init])) {
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = cpvsub(pos, cpv(0, 10));
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:BOMB_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [BombTarget class];
		_shape.data = self;
		
		_sprite = [CCSprite spriteWithFile:@"bomb.png"];
		
		[_sprite setPosition:pos];
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}

-(void)updCovered:(BOOL)covered {
	isCovered = covered;
	
	if ([self isCovered])
		[_sprite setOpacity:0];
	
	else
		[_sprite setOpacity:255];
}

-(void)dealloc {
	[super dealloc];
}
@end
