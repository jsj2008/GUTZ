//
//  BombTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 12.01.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTarget.h"

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#define BOMB_RADIUS 16.0f
#define BOMB_FORCE 64.0f

@interface BombTarget : BaseTarget <ChipmunkObject> {
	
}

-(void)updCovered:(BOOL)covered;

@end
