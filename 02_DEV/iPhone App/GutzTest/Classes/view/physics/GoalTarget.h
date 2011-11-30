//
//  GoalTarget.h
//  GutzTest
//
//  Created by Gullinbursti on 08/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#import "BaseTarget.h"

@interface GoalTarget : BaseTarget <ChipmunkObject> {
	
}

-(void)updateCovered:(BOOL)covered;


@end
