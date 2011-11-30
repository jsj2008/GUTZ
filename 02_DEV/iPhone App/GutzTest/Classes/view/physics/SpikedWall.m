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
			//_arrSpikes = [NSArray arrayWithArray:_arrLongSpikes];
			
		} else {
			width = 141;
			height = 13;
			strWall =  [NSString stringWithString:@"blocker_B_.png"];
			//_arrSpikes = [NSArray arrayWithArray:_arrShortSpikes];
		}
		
		_sprite = [CCSprite spriteWithFile:strWall];
		[_sprite setRotation:angle * 90];
		[_sprite setPosition:pos];
		
		
		_spikedBody = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		
		switch (angle) {
			case 0:
				_body.pos = cpvadd(pos, cpv(0, 6));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:width height:height];
				
				[_spikedBody setPos:cpvsub(pos, cpv(0, 4))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:width height:4.0];
				break;
				
			case 1:
				_body.pos = cpvadd(pos, cpv(6, 0));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:height height:width];
				
				[_spikedBody setPos:cpvsub(pos, cpv(8, 0))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:4.0 height:width];
				break;
				
			case 2:
				_body.pos = cpvsub(pos, cpv(0, 6));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:width height:height];
				
				[_spikedBody setPos:cpvadd(pos, cpv(0, 4))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:width height:4.0];
				break;
				
			case 3:
				_body.pos = cpvadd(pos, cpv(-6, 0));
				_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:height height:width];
				
				[_spikedBody setPos:cpvadd(pos, cpv(4, 0))];
				_spikedShape = [ChipmunkPolyShape boxWithBody:_spikedBody width:4.0 height:width];
				break;
		}
		
		_shape.friction = fric;
		_shape.elasticity = bnc;
		_shape.collisionType = [BaseWall class];
		_shape.data = self;
		
		_spikedShape.collisionType = [SpikedWall class];
		
		/*
		if (spikes == 2)
			_body.pos = cpvadd(pos, cpv(0, 6));
		
		else
			_body.pos = cpvsub(pos, cpv(0, 6));
		
		
		_arrLongSpikes = [NSArray arrayWithObjects:
								[NSNumber numberWithInt:-85], 
								[NSNumber numberWithInt:-45], 
								[NSNumber numberWithInt:-3], 
								[NSNumber numberWithInt:30], 
								[NSNumber numberWithInt:60], 
								[NSNumber numberWithInt:93], nil];
		
		_arrShortSpikes = [NSArray arrayWithObjects:
								[NSNumber numberWithInt:-50], 
								[NSNumber numberWithInt:-10], 
								[NSNumber numberWithInt:25], 
								[NSNumber numberWithInt:55], nil];
		*/
		
		
		
		//if (spikes == 1)
		//	[_sprite setRotation:180];
		
		//_shape = [ChipmunkStaticPolyShape boxWithBody:_body width:width height:height];
		//_shape.friction = fric;
		//_shape.elasticity = bnc;
		//_shape.collisionType = [BaseWall class];
		//_shape.data = self;
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, _spikedShape, nil) retain];
	}
	
	return (self);
}

-(void)makeSpikes {
	int offset;
	
	switch (spikes) {
		case 1:
			offset = 10;
			break;
		
		case 2:
			offset = -10;
	}
	
	
	//[_space add:_spikedShape];
	
	/*
	for (NSNumber *number in _arrSpikes) {
		ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		body.pos = cpv(_body.pos.x + [number intValue], _body.pos.y + offset);
		
		ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:15 height:10];
		shape.collisionType = [SpikedWall class];
		[_space add:shape];
	}
	*/
}

-(void)dealloc {
	[super dealloc];
}

@end
