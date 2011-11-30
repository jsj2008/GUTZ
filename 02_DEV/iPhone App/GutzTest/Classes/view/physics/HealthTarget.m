//
//  HealthTarget.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.28.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HealthTarget.h"

@implementation HealthTarget

-(id)initAtPos:(CGPoint)pos type:(int)kind {
	if ((self = [super init])) {
		
		_type = kind;
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:HEALTH_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [HealthTarget class];
		_shape.data = self;
		
		
		_sprite = [CCSprite spriteWithFile:@"bandAid.png"];
		[_sprite setColor:ccc3(128, 128, 128)];
		[_sprite setPosition:pos];
		
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}

-(void)updateCovered:(BOOL)covered {
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
