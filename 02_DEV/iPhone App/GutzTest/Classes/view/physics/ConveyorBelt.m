//
//  ConveyorBelt.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.25.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ConveyorBelt.h"

@implementation ConveyorBelt

-(id)initAtPos:(cpVect)pos width:(int)size speed:(float)spd {
	if ((self = [super init])) {
		
		_body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		_body.pos = pos;
		
		width = size;
		speed = spd;
		
		int segs = width / SEG_SIZE;
		
		for (int i=0; i<segs; i++) {
			
		}
		
		_sprite = [CCSprite spriteWithFile:@"conveyorBelt.png"];
		[_sprite setPosition:pos];
		
		_shape = [ChipmunkPolyShape boxWithBody:_body width:width height:24.0f];
		_shape.friction = 1.0;
		_shape.elasticity = 0.2;
		_shape.collisionType = [ConveyorBelt class];
		_shape.data = self;
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}

@end
