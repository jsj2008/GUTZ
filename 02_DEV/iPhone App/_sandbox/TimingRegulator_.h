//
//  TimingCoordinator.h
//  GutzTest
//
//  Created by Gullinbursti on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "cocos2d.h"


@interface TimingRegulator : CCNode {
    
	CCNode *lvlTimekeeper;
	CCNode *hudStarsTimekeeper;
	
	BOOL hasLvlClock;
	BOOL hasStarClock;
	
	BOOL isLvlClockRunning;
	BOOL isStarClockRunning;
	
	int lvlTime;
	NSMutableArray *arrLvlTime;
	
}

+(id)init;

-(void)restartLvlClock;
-(void)pauseLvlClock;
-(void)resumeLvlClock;


-(void)toggleStarsClock;


-(int)lvlTimeByNumer;

@property (nonatomic, retain) CCNode *lvlTimekeeper;
@property (nonatomic, retain) CCNode *hudStarsTimekeeper; 
@property (nonatomic, retain) NSMutableArray *arrLvlTime; 

@end
