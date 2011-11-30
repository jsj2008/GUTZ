//
//  ConveyorBelt.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.25.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#define SEG_SIZE 32.0

@interface ConveyorBelt : BasePhysicsSprite <ChipmunkObject> {
	
	float speed;
	int width;
	
	CGSize _size;
	cpVect _ptMin;
	cpVect _ptMax;
	
	NSTimer *_cycleTimer;
	NSMutableArray *_arrBlocks;
}

-(id)initAtPos:(cpVect)pos width:(int)size speed:(float)spd;
-(void)toggle:(BOOL)isRunning;
-(void)cycleBlocks:(id)sender;
@end
