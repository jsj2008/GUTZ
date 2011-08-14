//
//  LevelDataPlistParser.h
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasePlistParser.h"


@interface LevelDataPlistParser : BasePlistParser {
    
	NSArray *arrScoreAmt;
	NSArray *arrGoalCoords;
	
}


@property (nonatomic, retain) NSArray *arrScoreAmt;
@property (nonatomic, retain) NSArray *arrGoalCoords;

-(id) init;
-(id) initWithFile;

@end
