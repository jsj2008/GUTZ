//
//  Punter.h
//  GutzTest
//
//  Created by Matthew Holcombe on 12.01.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

@interface Punter : BasePhysicsSprite <ChipmunkObject> {
	
	float _interval;
	float _force;
	
	NSTimer *_timer;
	BOOL _isActive;
	BOOL _isDirInc;
	
}

-(id)initAtPos:(cpVect)pos interval:(int)itv force:(float)str;
-(void)toggle:(BOOL)isActive;
-(void)fire:(id)sender;
@end
