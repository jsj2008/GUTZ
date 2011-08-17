//
//  GoalTarget.m
//  GutzTest
//
//  Created by Gullinbursti on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoalTarget.h"

@implementation GoalTarget

@synthesize ind;
@synthesize isCovered;
@synthesize isCleared;

-(id)initAtPos:(CGPoint)pos {
	
	if ((self = [super init])) {
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [GoalTarget class];
		_shape.data = self;
		
		
		_sprite = [CCSprite spriteWithFile:@"target.png"];
		[_sprite setPosition:pos];
		[_sprite setScale:0.33];
		
		
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
		[_sprite setOpacity:128];
	
	else
		[_sprite setOpacity:255];
}


- (void)dealloc {
	[_sprite release];
	
	[super dealloc];
}

@end
