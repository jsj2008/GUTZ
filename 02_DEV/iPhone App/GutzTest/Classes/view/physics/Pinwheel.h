//
//  Pinwheel.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.20.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

@interface Pinwheel : BasePhysicsSprite <ChipmunkObject> {
	
	BOOL _isClockwise;
	float _speed;
	
}

-(id)initAtPos:(CGPoint)pos spinsClockwise:(BOOL)spins speed:(float)spd;
-(void)updRot;

@end
