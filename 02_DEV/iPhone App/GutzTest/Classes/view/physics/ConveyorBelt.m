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
		
		set = [NSMutableSet set];
		chipmunkObjects = set;
		
		_arrBlocks = [[NSMutableArray alloc] init];
		_ptPos = pos;
		_body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
		_body.pos = _ptPos;
		
		width = size;
		speed = spd;
		
		_sprite = [CCSprite spriteWithFile:@"conveyorBelt.png"];
		[_sprite setPosition:pos];
		
		_shape = [ChipmunkPolyShape boxWithBody:_body width:width height:4.0f];
		_shape.friction = 1.0;
		_shape.elasticity = 0.2;
		_shape.collisionType = [ConveyorBelt class];
		_shape.data = self;
		
		//chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
		
		int segs = width / SEG_SIZE;
		_ptMin = cpvadd(cpvsub(_ptPos, cpv(width * 0.5f, 0)), cpvzero);
		_ptMax = cpvsub(cpvadd(_ptPos, cpv(width * 0.5f, 0)), cpv(SEG_SIZE * 0.5f, 0));
		
		/*
		for (int i=0; i<segs; i++) {
			ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
			[body setPos:cpvadd(_ptPos, cpv(((SEG_SIZE * 0.5f) + (-width * 0.5f)) + (i * SEG_SIZE), ((i % 2) * 8) - 4))];
			ChipmunkPolyShape *shape = [ChipmunkPolyShape boxWithBody:body width:SEG_SIZE height:24];
		
			shape.friction = 1.0f;
			shape.elasticity = 0.0f;
			
			[_arrBlocks addObject:body];
			[set addObject:shape];
		}
		*/
		
		if (speed < 0) {		
			cpVect polyVerts[] = {
				cpv(0.0, 24.0), 
				cpv(SEG_SIZE * 0.5, 0.0),
				cpv(0.0, 0.0)
			};
			
			for (int i=0; i<segs; i++) {
				ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
				[body setPos:cpvadd(_ptPos, cpv(((SEG_SIZE * 0.5f) + (-width * 0.5f)) + (i * SEG_SIZE), -8))];
				
				ChipmunkPolyShape *shape = [[ChipmunkPolyShape alloc] initWithBody:body count:3 verts:polyVerts offset:cpvzero];
				shape.friction = 1.0f;
				shape.elasticity = 0.0f;
				
				[_arrBlocks addObject:body];
				[set addObject:shape];
			}
		
		} else {
			cpVect polyVerts[] = {
				cpv(SEG_SIZE * 0.5, 24.0), 
				cpv(SEG_SIZE * 0.5, 0.0),
				cpv(0.0, 0.0)
			};
			
			for (int i=0; i<segs; i++) {
				ChipmunkBody *body = [ChipmunkBody bodyWithMass:INFINITY andMoment:INFINITY];
				[body setPos:cpvadd(_ptPos, cpv(((SEG_SIZE * 0.5f) + (-width * 0.5f)) + (i * SEG_SIZE), -8))];
				
				ChipmunkPolyShape *shape = [[ChipmunkPolyShape alloc] initWithBody:body count:3 verts:polyVerts offset:cpvzero];
				shape.friction = 1.0f;
				shape.elasticity = 0.0f;
				
				[_arrBlocks addObject:body];
				[set addObject:shape];
			}
		}
		
		[self toggle:YES];
	}
	
	return (self);
}

-(void)toggle:(BOOL)isRunning {
	
	if (isRunning)
		_cycleTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(cycleBlocks:) userInfo:nil repeats:YES];
	
	else {
		[_cycleTimer invalidate];
		_cycleTimer = nil;
	}
}

-(void)cycleBlocks:(id)sender {
	for (ChipmunkBody *body in _arrBlocks) {
		[body setPos:cpv(body.pos.x + speed, body.pos.y)];
		
		if (speed > 0) {
			if (body.pos.x > _ptMax.x)
				[body setPos:cpv(_ptMin.x, body.pos.y)];
		
		} else {
			if (body.pos.x < _ptMin.x)
				[body setPos:cpv(_ptMax.x, body.pos.y)];
		}
	}
}

-(void)dealloc {
	[super dealloc];
}

@end
