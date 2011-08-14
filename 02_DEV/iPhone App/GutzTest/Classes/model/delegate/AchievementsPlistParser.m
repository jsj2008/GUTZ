//
//  AchievementsPlistParser.m
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AchievementsPlistParser.h"


@implementation AchievementsPlistParser

@synthesize iTimestamp;
@synthesize iScore;
@synthesize iTime;
@synthesize iStars;

-(id)init {
	NSLog(@"-/> %@.%@() </-", [self class], @"init");
	
	if ((self = [self initWithFile])) {
		
		// pull out plist entries into array
		for (int i=0; i<[arrItmEntries count]; i++) {
			NSLog(@"  -/> arrItems[%d]=(%@) </-", i, [arrItmEntries objectAtIndex:i]);
			
			//NSDictionary* dicLvlStats = [[NSDictionary alloc] initWithDictionary:<#(NSDictionary *)#>:[arrItmEntries :i], nil];
			
			//for (int j=0; j<[[dicLvlStats allKeys] count]; j++) {
			//	NSString* keyName = [[dicLvlStats allKeys] objectAtIndex:j];
		//		NSLog(@"  -/> arrItems[%d].dicLvlStats[%d_%@]=(%@) </-", i, j, [arrItmEntries objectAtIndex:i], keyName);
		//	}
		}
		
	}
	
	return (self);

	
}


//urlArtistPage = [dicTopLvl objectForKey:[arrItmEntries objectAtIndex:0]];
//urlMoreInfo = [dicTopLvl objectForKey:[arrItmEntries objectAtIndex:1]];
//urlStudioPage = [dicTopLvl objectForKey:[arrItmEntries objectAtIndex:5]];
//isPushes = [dicTopLvl objectForKey:[arrItmEntries objectAtIndex:3]];
//isSound = [dicTopLvl objectForKey:[arrItmEntries objectAtIndex:4]];
//lastPlayed = [dicTopLvl objectForKey:[arrItmEntries objectAtIndex:2]];

-(id)initWithFile {
	//NSLog(@"-/> %@.%@(\"%@\") </-", [self class], @"initWithFile", RESRC_NAME);
	NSLog(@"-/> %@.%@(\"%@\") </-", [self class], @"initWithFile", @"Achievements");
	
	// invoke inherited
	return ([super initWithFile:@"Achievements" path:@""]);
}

@end
