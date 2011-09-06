//
//  StarTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

#define STAR_RADIUS 9.0f

@interface StarTarget : BasePhysicsSprite <ChipmunkObject> {
	
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
