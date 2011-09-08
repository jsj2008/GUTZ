//
//  StarGoalTarget.m
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StarGoalTarget.h"

@implementation StarGoalTarget

-(id)initAtPos:(CGPoint)pos {
	if ((self = [super init])) {
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:STAR_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [StarGoalTarget class];
		_shape.data = self;
		
		
		_sprite = [CCSprite spriteWithFile:@"inGamePin.png"];
		[_sprite setColor:ccc3(128, 64, 255)];
		[_sprite setPosition:pos];
		
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}

@end
