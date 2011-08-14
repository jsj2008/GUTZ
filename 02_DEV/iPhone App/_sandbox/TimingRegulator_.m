//
//  TimingCoordinator.m
//  GutzTest
//
//  Created by Gullinbursti on 07/02/11. //  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimingRegulator.h"

#import "cocos2d.h"

#import "CCScheduler.h"


@implementation TimingRegulator


@synthesize lvlTimekeeper;
@synthesize hudStarsTimekeeper;
@synthesize arrLvlTime;


+(id)init {
	
	
	
	
}

-(void)restartLvlClock {
	
}


-(void)pauseLvlClock {	
	
}


-(void)resumeLvlClock {
	
}


-(NSInteger *)lvlTimeByNumber:(int)lvl {
	return ([arrLvlTime objectAtIndex:(NSInteger*)lvl]);
}

-(void)toggleStarsClock:(BOOL)isRunning {
	
	if (isRunning)
		[CCScheduler 
	
}

@end
