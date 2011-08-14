//
//  TimeUtils.m
//  GutzTest
//
//  Created by Gullinbursti on 07/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeUtils.h"

static TimeUtils *singleton = nil;

@implementation TimeUtils

+(TimeUtils *) singleton {
	
	if (!singleton) {
		
		if ([[TimeUtils class] isEqual:[self class]])
			singleton = [[TimeUtils alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	return (singleton);
}


-(int) minutesFromSeconds:(int)seconds {
	return (seconds / 60);
}


-(int) secondsRemain:(int)time {
	return (time - ([self minutesFromSeconds:time] * 60));
}
@end
