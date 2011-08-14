//
//  SettingsPlistParser.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsPlistParser.h"

@implementation SettingsPlistParser

@synthesize urlMoreInfo;
@synthesize urlArtistPage;
@synthesize urlStudioPage;

@synthesize isPushes;
@synthesize isSounds;
@synthesize lastPlayed;

-(id) init {
	NSLog(@"-/> %@.init%@ </-", [self class], @".()");
	
	if ((self = [self initWithFile])) {
		
		// set the url vals
		urlArtistPage = [[super dicTopLvl] objectForKey:@"Artist URL"];
		urlMoreInfo = [[super dicTopLvl] objectForKey:@"GUTZ Info"];
		urlStudioPage = [[super dicTopLvl] objectForKey:@"Studio URL"];
		isPushes = (BOOL *)[[super dicTopLvl] objectForKey:@"Pushes Enabled"];
		isSound = (BOOL *)[[super dicTopLvl] objectForKey:@"Sounds Enabled"];
		lastPlayed = [[super dicTopLvl] objectForKey:@"Played Timestamp"];
	}
	
	return (self);
}


-(id) initWithFile {
	NSLog(@"-/> %@.%@(\"%@\") </-", [self class], @"initWithFile", @"Settings");
	
	// invoke inherited
	return ([super initWithFile:@"Settings" path:@""]);
}

@end
