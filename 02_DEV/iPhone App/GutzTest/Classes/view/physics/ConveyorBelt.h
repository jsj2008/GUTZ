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

#define SEG_SIZE 16.0

@interface ConveyorBelt : BasePhysicsSprite <ChipmunkObject> {
	
	float speed;
	int width;
	
}

-(id)initAtPos:(cpVect)pos width:(int)size speed:(float)spd;

@end
