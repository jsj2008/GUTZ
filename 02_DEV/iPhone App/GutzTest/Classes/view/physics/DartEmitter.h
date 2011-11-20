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

#define EMITTER_WIDTH 8
#define EMITTER_HEIGHT 24

@interface DartEmitter : BasePhysicsSprite <ChipmunkObject> {
	int ind;
	int type;
	
	float interval;
	float speed;
	BOOL _isFiring;
	
	NSTimer *_fireTimer;
	NSMutableArray *arrDarts;
}

-(id)initAtPos:(CGPoint)pos fires:(int)dir freq:(float)itv speed:(float)spd;
-(void)toggleFiring:(BOOL)isFiring;
-(void)fire:(id)sender;
-(void)updDarts;

@property (nonatomic) int ind;
@property (nonatomic, retain) NSMutableArray *arrDarts;
@end
