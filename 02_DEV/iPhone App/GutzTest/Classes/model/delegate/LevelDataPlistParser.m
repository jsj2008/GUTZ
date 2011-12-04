//
//  LevelDataPlistParser.m
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelDataPlistParser.h"


@implementation LevelDataPlistParser

@synthesize arrHealthData;
@synthesize arrStarData;
@synthesize arrPointData;
@synthesize arrWallData;
@synthesize arrGoalData;
@synthesize arrTrapData;
@synthesize arrBombData;
@synthesize arrStudData;
@synthesize arrDartData;
@synthesize arrPunterData;
@synthesize arrHandWheelData;
@synthesize arrConveyorData;

-(id)init {
	NSLog(@"-/> %@.init%@ </-", [self class], @".()");
	
	if (!(self = [super init]))
		return (nil);
	
	return (self);
}
				 
				 
-(id) initWithLevel:(int)ind {
	NSLog(@"-/> %@.%@(\"%@\") </-", [self class], @"initWithFile", @"LevelObjects");
	
	if ((self = [super initWithFile:[NSString stringWithFormat:@"LevelData_%02d", ind] path:@""])) {
		
		arrHealthData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"healths"]];
		arrStarData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"stars"]];
		arrPointData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"pickups"]];
		arrWallData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"walls"]];
		arrGoalData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"goals"]];
		arrTrapData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"traps"]];
		arrBombData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"bombs"]];
		arrStudData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"studs"]];
		arrDartData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"darts"]];
		arrPunterData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"punters"]];
		arrHandWheelData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"handwheels"]];
		arrConveyorData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"conveyors"]];
	}
	
	return (self);
}

@end
