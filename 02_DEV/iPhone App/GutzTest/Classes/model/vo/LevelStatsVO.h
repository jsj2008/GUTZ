//
//  LevelStatsVO.h
//  GutzTest
//
//  Created by Gullinbursti on 07/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LevelStatsVO : NSObject {
    
	int ind;
	
	int topScore;
	int actScore;
	int topTime;
	int actTime;
	
	NSNumber *commenceTime;
	NSNumber *concludeTime;
}

-(void) populate;
-(void) store;




@property (nonatomic, retain) NSNumber *commenceTime;
@property (nonatomic, retain) NSNumber *concludeTime;



@end
