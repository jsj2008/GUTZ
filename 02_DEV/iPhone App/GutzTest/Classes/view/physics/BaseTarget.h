//
//  BaseTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#define TARGET_RADIUS 16.0f

@interface BaseTarget : BasePhysicsSprite <ChipmunkObject> {
	
	int ind;
	BOOL isCovered;
	BOOL isCleared;
}

-(id)initAtPos:(CGPoint)pos;
-(void)updCovered:(BOOL)covered;
-(void)remove;

@property (nonatomic) int ind;
@property (nonatomic) BOOL isCovered;
@property (nonatomic) BOOL isCleared;

@end
