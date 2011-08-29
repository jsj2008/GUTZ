//
//  LevelDataPlistParser.m
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelDataPlistParser.h"


@implementation LevelDataPlistParser

@synthesize arrWallData;
@synthesize arrGoalData;


-(id)init {
	return (self);
}
				 
				 
-(id) initWithLevel:(int)ind {
	NSLog(@"-/> %@.%@(\"%@\") </-", [self class], @"initWithFile", @"LevelObjects");
	
	if ((self = [super initWithFile:[NSString stringWithFormat:@"LevelData_0%d", ind] path:@""])) {
		
		arrWallData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"walls"]];
		arrGoalData = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"goals"]];
	}
	
	return (self);
}

@end
