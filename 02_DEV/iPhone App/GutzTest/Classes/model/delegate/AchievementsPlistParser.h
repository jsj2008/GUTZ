//
//  AchievementsPlistParser.h
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasePlistParser.h"

//#define RESRC_NAME @"Achievements"


@interface AchievementsPlistParser : BasePlistParser {
    int iTimestamp;
	int iScore;
	int iStars;
	int iTime;
}

-(id)initWithFile;

@property (nonatomic, readwrite) int iTimestamp;
@property (nonatomic, readwrite) int iScore;
@property (nonatomic, readwrite) int iStars;
@property (nonatomic, readwrite) int iTime;

@end
