//
//  DartEmitter.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.19.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#import "Dart.h"

#define EMITTER_WIDTH 22
#define EMITTER_HEIGHT 55

@interface DartEmitter : BasePhysicsSprite <ChipmunkObject> {
	int ind;
	int type;
	
	float interval;
	float speed;
	BOOL _isFiring;
	
	NSTimer *_fireTimer;
	NSMutableArray *arrDarts;
	NSArray *arrFrames;
}

-(id)initAtPos:(CGPoint)pos fires:(int)dir freq:(float)itv speed:(float)spd;
-(void)toggleFiring:(BOOL)isFiring;
-(void)fire:(id)sender;
-(void)updDarts;
-(void)flush;

@property (nonatomic) int ind;
@property (nonatomic, retain) NSMutableArray *arrDarts;
@end
