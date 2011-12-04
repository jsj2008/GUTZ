//
//  PointTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.28.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseTarget.h"

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"


#define POINT_RADIUS 6.0f

@interface PointTarget : BaseTarget <ChipmunkObject> {
	int _type;
	int points;
}

@property (nonatomic) int points;

-(id)initAtPos:(CGPoint)pos type:(int)kind points:(int)pts;
-(void)updCovered:(BOOL)covered;

@end
