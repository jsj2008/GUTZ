//
//  GoalTarget.h
//  GutzTest
//
//  Created by Gullinbursti on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#import "BasePhysicsSprite.h"

#define RADIUS 18.0f

@interface GoalTarget : BasePhysicsSprite <ChipmunkObject> {
	
	int ind;
	BOOL isCovered;
	BOOL isCleared;
}

-(id)initAtPos:(CGPoint)pos;
-(void)updateCovered:(BOOL)covered;

@property (nonatomic) int ind;
@property (nonatomic) BOOL isCovered;
@property (nonatomic) BOOL isCleared;

@end
