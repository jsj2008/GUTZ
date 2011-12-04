//
//  HealthTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.28.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTarget.h"

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"


#define HEALTH_RADIUS 16.0f

@interface HealthTarget : BaseTarget <ChipmunkObject> {
	int _type;
}

-(id)initAtPos:(CGPoint)pos type:(int)kind;
-(void)updCovered:(BOOL)covered;
@end
