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
		
		NSLog(@"type:%d", _type);
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:HEALTH_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [HealthTarget class];
		_shape.data = self;
		
		switch (_type) {
			case 1:
				_sprite = [CCSprite spriteWithFile:@"bandAid.png"];
				break;
				
			case 2:
				_sprite = [CCSprite spriteWithFile:@"steak.png"];
				break;
				
			case 3:
				_sprite = [CCSprite spriteWithFile:@"chicken.png"];
				break;
				
			case 4:
				_sprite = [CCSprite spriteWithFile:@"doughnut.png"];
				break;
				
			case 5:
				_sprite = [CCSprite spriteWithFile:@"cola.png"];
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
