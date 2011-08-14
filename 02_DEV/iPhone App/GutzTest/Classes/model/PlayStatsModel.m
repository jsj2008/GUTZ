//
//  PlayStatsModel.m
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayStatsModel.h"

#import "cocos2d.h"

@implementation PlayStatsModel

@synthesize currScore = currScore_;
@synthesize currLvl = currLvl_;
@synthesize gameTimestamp = gameTimestamp_;
@synthesize lvlInTimestamp = lvlInTimestamp_;
@synthesize lvlOutTimestamp = lvlOutTimestamp_;


static PlayStatsModel *singleton = nil;

+(PlayStatsModel *) singleton {
	if (!singleton) {
		
		if( [ [PlayStatsModel class] isEqual:[self class]] )
			singleton = [[PlayStatsModel alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	
	return (singleton);
}


+(id) alloc {
	NSAssert(singleton == nil, @"Attempted to allocate a second instance of a singleton.");
	return ([super alloc]);
}




 


-(void) incScore:(int)amt {
	//NSLog(@"incScore:[+%d] = %d", amt, currScore_ + amt);
	
	currScore_ += amt;
}


-(void) updScore:(int)val {
	NSLog(@"updScore:[%d]", val);
	
	currScore_ = val;
}

-(void) tareScore {
	NSLog(@"tareScore");
	
	[self updScore:0];
}


-(void) procurePlists {
	
}


-(void) commenceLvl {
	
}

-(void) concludeLvl {
	
}

-(void) endGame {
	
}



@end
