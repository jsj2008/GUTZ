//
//  PointTarget.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.28.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PointTarget.h"

@implementation PointTarget

@synthesize points;

-(id)initAtPos:(CGPoint)pos type:(int)kind points:(int)pts {
	if ((self = [super init])) {
		
		_type = kind;
		points = pts;
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:POINT_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [PointTarget class];
		_shape.data = self;
		
		switch (_type) {
			case 1:
				_sprite = [CCSprite spriteWithFile:@"ptPickup.png"];
				break;
				
			case 2:
				_sprite = [CCSprite spriteWithFile:@"jewel.png"];
				break;
		}
		
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
