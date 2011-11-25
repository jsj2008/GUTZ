//
//  BaseWall.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.22.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

@interface BaseWall : BasePhysicsSprite <ChipmunkObject> {
	int ind;
	int type;
	int rot;
}

-(id)initAtPos:(CGPoint)pos large:(BOOL)isLarge rotation:(int)ang friction:(float)fric bounce:(float)bnc;

@end
