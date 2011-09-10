//
//  BasePhysicsLayer.m
//  GutzTest
//
//  Created by Matthew Holcombe on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsLayer.h"

#import "GameConfig.h"
#import "RandUtils.h"

#import "ChipmunkDebugNode.h"


static NSString *borderType = @"borderType";


@implementation BasePhysicsLayer

-(id)initWithBackround:(NSString *)asset {
	if ((self = [super initWithBackround:asset])) {
		//[self setupChipmunk];
	}
	
	return (self);
}


-(id)initWithBackround:(NSString *)asset position:(CGPoint)pos {
	
	if ((self = [super initWithBackround:asset position:pos])) {
		CCSprite *sprite = [CCSprite spriteWithFile: asset];
		sprite.position = ccp(pos.x, pos.y);
		[self addChild:sprite z:0];
		
		//[self setupChipmunk];
	}
		
	return (self);
}


-(id)initWithColor:(ccColor4B)color {
	if ((self = [super initWithColor:color])) {
		//[self setupChipmunk];
	}
	
	return (self);
}



-(void)setupChipmunk {
	cpInitChipmunk();
	
	_space = [[ChipmunkSpace alloc] init];
	_space.gravity = cpv(0, 0);
	
	CGSize wins = [[CCDirector sharedDirector] winSize];
	CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
	
	if (kDrawChipmunkObjs == 1)
		[self addChild:[ChipmunkDebugNode debugNodeForSpace:_space] z:0 tag:666];
	
	
	[_space addBounds:rect thickness:532 elasticity:1 friction:1 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	 _accBlob1 = [[JellyBlob alloc] initWithPos:cpv(164, 100) radius:32 count:16];
	 [_space add:_accBlob1];
	 
	 _accBlob2 = [[JellyBlob alloc] initWithPos:cpv(160, 120) radius:16 count:8];
	 [_space add:_accBlob2];
	 
	 _accBlob3 = [[JellyBlob alloc] initWithPos:cpv(140, 210) radius:24 count:12];
	 [_space add:_accBlob3];
	 
	 _accBlob4 = [[JellyBlob alloc] initWithPos:cpv(40, 232) radius:8 count:8];
	 [_space add:_accBlob4];
	 
	 [self schedule:@selector(physicsStepper:)];
	 [self schedule:@selector(mobWiggler:) interval:0.25f + (CCRANDOM_0_1() * 0.125f)];
}

-(void) physicsStepper: (ccTime) dt {
	//NSLog(@"PlayScreenLayer.physicsStepper(%0.000000f)", [[CCDirector sharedDirector] getFPS]);
	[_space step:1.0 / 60.0];
}


-(void) mobWiggler:(id)sender {
	
	cpFloat maxForce = 4.0f;
	cpFloat rndForce = [[RandUtils singleton] rndFloat:0.0f max:maxForce]; //CCRANDOM_0_1() * maxForce;
	
	
	switch ([[RandUtils singleton] diceRoller:4]) {
		case 1:
			[_accBlob1 wiggleWithForce:[[RandUtils singleton] rndIndex:32] force:rndForce];
			break;
			
		case 2:
			[_accBlob2 wiggleWithForce:[[RandUtils singleton] rndIndex:16] force:rndForce];
			break;
			
		case 3:
			[_accBlob3 wiggleWithForce:[[RandUtils singleton] rndIndex:24] force:rndForce];
			break;
			
		case 4:
			[_accBlob4 wiggleWithForce:[[RandUtils singleton] rndIndex:8] force:rndForce];
			break;
	}
}


-(void) draw {
	//NSLog(@"///////[DRAW]////////");
	
	[super draw];
	
	[_accBlob1 draw];
	[_accBlob2 draw];
	[_accBlob3 draw];
	[_accBlob4 draw];
	
	
	//for (int i=0; i<[arrGibs count]; i++) {
	//	ChipmunkShape *shape = (ChipmunkShape *)[arrGibs objectAtIndex:i];
	//	ccDrawCircle(shape.body.pos, 3, 360, 4, NO);
	//}
}


-(void)dealloc {
	[super dealloc];
	
	[_accBlob1 release];
	[_accBlob2 release];
	[_accBlob3 release];
	[_accBlob4 release];
	
	[_space dealloc];
	_space = nil;
}

@end
