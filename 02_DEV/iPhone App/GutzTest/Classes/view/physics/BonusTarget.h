//
//  StarTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTarget.h"

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

#define BONUS_RADIUS 9.0f

@interface BonusTarget : BaseTarget <ChipmunkObject> {
	
}

-(id)initAtPos:(CGPoint)pos;
-(void)updateCovered:(BOOL)covered;

@end
