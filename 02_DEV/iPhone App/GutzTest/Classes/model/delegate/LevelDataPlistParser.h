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
    
	NSArray *arrWallData;
	NSArray *arrGoalData;
	
}


@property (nonatomic, retain) NSArray *arrWallData;
@property (nonatomic, retain) NSArray *arrGoalData;

-(id) initWithLevel:(int)ind;

@end
