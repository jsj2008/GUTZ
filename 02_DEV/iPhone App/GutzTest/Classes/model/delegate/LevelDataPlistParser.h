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
	
	NSArray *arrHealthData;
	NSArray *arrPointData;
	NSArray *arrWallData;
	NSArray *arrGoalData;
	NSArray *arrTrapData;
	NSArray *arrStudData;
	NSArray *arrDartData;
	NSArray *arrHandWheelData;
	NSArray *arrConveyorData;
}


@property (nonatomic, retain) NSArray *arrHealthData;
@property (nonatomic, retain) NSArray *arrPointData;
@property (nonatomic, retain) NSArray *arrWallData;
@property (nonatomic, retain) NSArray *arrGoalData;
@property (nonatomic, retain) NSArray *arrTrapData;
@property (nonatomic, retain) NSArray *arrStudData;
@property (nonatomic, retain) NSArray *arrDartData;
@property (nonatomic, retain) NSArray *arrHandWheelData;
@property (nonatomic, retain) NSArray *arrConveyorData;

-(id) initWithLevel:(int)ind;

@end
