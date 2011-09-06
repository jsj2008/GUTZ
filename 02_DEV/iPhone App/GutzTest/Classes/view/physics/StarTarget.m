//
//  StarTarget.m
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StarTarget.h"

@implementation StarTarget

@synthesize ind;
@synthesize isCovered;
@synthesize isCleared;

-(id)initAtPos:(CGPoint)pos {
	
	if ((self = [super init])) {
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:STAR_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [StarTarget class];
		_shape.data = self;
		
		
		_sprite = [CCSprite spriteWithFile:@"debug_node-01.png"];
		[_sprite setPosition:pos];
		[_sprite setScale:1.5f];
		
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	
	return (self);
	
}



- (void)updatePosition {
	[super updatePosition];
	
	[_sprite setPosition:_body.pos];
	
}

- (void)updateCovered:(BOOL)covered {
	isCovered = covered;
	
	if ([self isCovered])
		[_sprite setOpacity:0];
	
	else
		[_sprite setOpacity:255];
}


- (void)dealloc {
	[_sprite release];
	
	[super dealloc];
}


@end
