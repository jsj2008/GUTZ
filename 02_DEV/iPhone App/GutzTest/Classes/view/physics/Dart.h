//
//  Dart.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.19.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#define DART_RADIUS 2

@interface Dart : BasePhysicsSprite <ChipmunkObject> {
	int ind;
	int _dir;
	float _speed;
}

-(id)initAtPos:(CGPoint)pos fires:(int)dir speed:(float)spd;
-(void)updPos;

@end
