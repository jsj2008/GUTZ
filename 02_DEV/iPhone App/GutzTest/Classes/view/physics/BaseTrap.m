//
//  BaseTrap.m
//  GutzTest
//
//  Created by Matthew Holcombe on 11.19.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTrap.h"

@implementation BaseTrap

@synthesize ind;
@synthesize isCovered;
@synthesize isCleared;

-(id)initAtPos:(CGPoint)pos {
	if ((self = [super init])) {
		
		_body = [[ChipmunkBody alloc] initWithMass:1 andMoment:INFINITY];
		_body.pos = pos;
		
		_shape = [ChipmunkStaticCircleShape circleWithBody:_body radius:BASE_RADIUS offset:cpvzero];
		_shape.elasticity = 0.0f;
		_shape.friction = 0.0f;		
		_shape.collisionType = [BaseTrap class];
		_shape.data = self;
		
		_frame1Sprite = [CCSprite spriteWithFile:@"enemy_spike_f1.png"];
		_frame2Sprite = [CCSprite spriteWithFile:@"enemy_spike_f2.png"];
		_frame2Sprite.visible = NO;
		
		
		_sprite = [CCSprite new];
		[_sprite addChild:_frame1Sprite];
		[_sprite addChild:_frame2Sprite];
		
		[_sprite setPosition:pos];
		
		_isFrame1 = YES;
		
		chipmunkObjects = [ChipmunkObjectFlatten(_shape, nil) retain];
	}
	
	return (self);
}


-(void)onFrameChange:(id)sender {
	
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
