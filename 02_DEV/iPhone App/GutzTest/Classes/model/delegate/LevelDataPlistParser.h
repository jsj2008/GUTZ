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
	NSArray *arrTrapData;
	NSArray *arrStudData;
	NSArray *arrDartData;
}


@property (nonatomic, retain) NSArray *arrWallData;
@property (nonatomic, retain) NSArray *arrGoalData;
@property (nonatomic, retain) NSArray *arrTrapData;
@property (nonatomic, retain) NSArray *arrStudData;
@property (nonatomic, retain) NSArray *arrDartData;

-(id) initWithLevel:(int)ind;

@end
