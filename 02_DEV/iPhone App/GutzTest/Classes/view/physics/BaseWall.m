//
//  BaseWall.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.22.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseWall.h"

@implementation BaseWall

-(id)initAtPos:(CGPoint)pos large:(BOOL)isLarge rotation:(int)ang friction:(float)fric bounce:(float)bnc {
	if ((self = [super init])) {
		
		int width;
		int height;
		NSString *strWall;
		
		_body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		_body.pos = cpvadd(pos, cpv(0, 6));
		
		if (isLarge) {
			width = 217;
			height = 13;
			strWall = [NSString stringWithString:@"blocker.png"];
		
		} else {
			width = 141;
			height = 13;
			strWall = [NSString stringWithString:@"blocker_B_.png"];
		}
			
		_sprite = [CCSprite spriteWithFile:strWall];
		[_sprite setPosition:pos];
		
		_shape = [_space add:[ChipmunkStaticPolyShape boxWithBody:_body width:width height:height]];
		_shape.friction = fric;
		_shape.elasticity = bnc;
		_shape.collisionType = [BaseWall class];
		_shape.data = self;
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}

@end
