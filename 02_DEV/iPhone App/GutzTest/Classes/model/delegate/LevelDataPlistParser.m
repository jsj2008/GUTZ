//
//  LevelDataPlistParser.m
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelDataPlistParser.h"


@implementation LevelDataPlistParser

@synthesize arrScoreAmt;
@synthesize arrGoalCoords;


-(id)init {
	
	if ((self = [self initWithFile])) {
		
		arrScoreAmt = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"Scores"]];
		
	}
	
	return (self);
}
				 
				 
-(id) initWithFile {
	NSLog(@"-/> %@.%@(\"%@\") </-", [self class], @"initWithFile", @"LevelData");
	 
	// invoke inherited
	return ([super initWithFile:@"Settings" path:@""]);
}
	
@end
