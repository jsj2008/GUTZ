//
//  GoalTarget.m
//  GutzTest
//
//  Created by Gullinbursti on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoalTarget.h"

@implementation GoalTarget

-(id)initAtPos:(CGPoint)pos {
	if ((self = [super init])) {
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:TARGET_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [GoalTarget class];
		_shape.data = self;
		
		
		_sprite = [CCSprite spriteWithFile:@"inGamePin.png"];
		[_sprite setColor:ccc3(128, 64, 255)];
		[_sprite setPosition:pos];
		
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}



-(void)updPos {
	[super updPos];
	
	[_sprite setPosition:_body.pos];
	
}

-(void)updateCovered:(BOOL)covered {
	isCovered = covered;
	
	if ([self isCovered])
		[_sprite setOpacity:128];
	
	else
		[_sprite setOpacity:255];
}


-(void)dealloc {
	[_sprite release];
	
	[super dealloc];
}

@end
