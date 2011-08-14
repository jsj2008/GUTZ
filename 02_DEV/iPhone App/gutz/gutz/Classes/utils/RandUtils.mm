//
//  RandUtils.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RandUtils.h"


static RandUtils *singleton = nil;

@implementation RandUtils

+(RandUtils *) singleton {
	
	if (!singleton) {
		
		if ([[RandUtils class] isEqual:[self class]])
			singleton = [[RandUtils alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	return (singleton);
}


-(int) diceRoller:(int)sides {
	return ((arc4random() % sides) + 1);
}

-(int) randIndex:(int)max {
	return ((arc4random() % max) + 0);
}

@end

