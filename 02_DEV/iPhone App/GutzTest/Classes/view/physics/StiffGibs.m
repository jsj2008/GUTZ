//
//  StiffGibs.m
//  GutzTest
//
//  Created by Matthew Holcombe on 08.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StiffGibs.h"


@implementation StiffGibs



-(id)initAtPos:(CGPoint)pos {
	if ((self = [super init])) {
		
		_body = [[ChipmunkBody alloc] initWithMass:ORTHODOX_GIBS_MASS andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:ORTHODOX_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;
		_shape.collisionType = [StiffGibs class];
		_shape.data = self;
		
		_sprite = [CCSprite spriteWithFile:@"debug_node-00.png"];
		[_sprite setPosition:pos];
		[_sprite setScale:1.5f];
		
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}

@end
