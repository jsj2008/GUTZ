//
//  PointTarget.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.28.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PointTarget.h"

@implementation PointTarget

-(id)initAtPos:(CGPoint)pos type:(int)kind {
	if ((self = [super init])) {
		
		_type = kind;
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:TARGET_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [PointTarget class];
		_shape.data = self;
		
		switch (_type) {
			case 1:
				_sprite = [CCSprite spriteWithFile:@"ptPickup.png"];
				break;
		}
		
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
