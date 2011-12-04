//
//  StarGoalTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTarget.h"

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"


#define STAR_RADIUS 16.0f

@interface StarGoalTarget : BaseTarget <ChipmunkObject> {
	
}

-(void)updCovered:(BOOL)covered;

@end
