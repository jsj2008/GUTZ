//
//  RangedTrap.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTrap.h"

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

#define TRAP_RADIUS 8.0f
#define TRAP_WIDTH 56.0f
#define TRAP_HEIGHT 16.0f

@interface RangedTrap : BaseTrap <ChipmunkObject> {
	BOOL _isDirInc;
	BOOL _isVertical;
	float _speed;
	CGPoint _range;
}

-(id)initAtPos:(CGPoint)pos vertical:(BOOL)vert speed:(float)spd range:(CGPoint)rng;
-(void)updateCovered:(BOOL)covered;
-(void)updPos;

@end
