//
//  SpikedWall.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.22.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpikedWall.h"

@implementation SpikedWall

-(id)initAtPos:(CGPoint)pos large:(BOOL)isLarge spikes:(int)spiked rotation:(int)ang friction:(float)fric bounce:(float)bnc {
	if ((self = [super init])) {
		
		int width;
		int height;
		NSString *strWall;
		
		spikes = spiked;
		angle = ang;
		
		_body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		
		if (isLarge) {
			width = 217;
			height = 13;
			strWall =  [NSString stringWithString:@"blocker.png"];
			
		} else {
			width = 141;
			height = 13;
			strWall =  [NSString stringWithString:@"blocker_B_.png"];
		}
		
		_sprite = [CCSprite spriteWithFile:strWall];
		[_sprite setRotation:angle * 90];
		[_sprite setPosition:pos];
		
		
		_spikedBody = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		
		switch (angle) {
			case 0:
				_body.pos = cpvadd(pos, cpv(0, 12));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:width height:height];
				
				[_spikedBody setPos:cpvsub(pos, cpv(0, 4))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:width * 0.9 height:4.0];
				break;
				
			case 1:
				_body.pos = cpvadd(pos, cpv(12, 0));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:height height:width];
				
				[_spikedBody setPos:cpvsub(pos, cpv(8, 0))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:4.0 height:width * 0.9];
				break;
				
			case 2:
				_body.pos = cpvsub(pos, cpv(0, 12));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:width height:height];
				
				[_spikedBody setPos:cpvadd(pos, cpv(0, 4))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:width * 0.9 height:4.0];
				break;
				
			case 3:
				_body.pos = cpvadd(pos, cpv(-12, 0));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:height height:width];
				
				[_spikedBody setPos:cpvadd(pos, cpv(4, 0))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:4.0 height:width * 0.9];
				break;
		}
		
		_spikedShape.collisionType = [SpikedWall class];
		
		_shape.friction = fric;
		_shape.elasticity = bnc;
		_shape.collisionType = [BaseWall class];
		_shape.data = self;
				
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, _spikedShape, nil) retain];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}

@end
