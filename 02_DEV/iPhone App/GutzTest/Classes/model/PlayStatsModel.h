//
//  PlayStatsModel.h
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlayStatsModel : NSObject {
    
	int currScore_;
	int currLvl_;
	int gameTimestamp_;
	int lvlInTimestamp_;
	int lvlOutTimestamp_;
}

+(PlayStatsModel *) singleton;


-(void) procurePlists;
-(void) commenceLvl;
-(void) concludeLvl;
-(void) endGame;

-(void) incScore:(int)amt;
-(void) updScore:(int)val;
-(void) tareScore;



@property (nonatomic, readwrite, assign) int currScore;
@property (nonatomic, readwrite, assign) int currLvl;
@property (nonatomic, readwrite, assign) int gameTimestamp;
@property (nonatomic, readwrite, assign) int lvlInTimestamp;
@property (nonatomic, readwrite, assign) int lvlOutTimestamp;

@end
