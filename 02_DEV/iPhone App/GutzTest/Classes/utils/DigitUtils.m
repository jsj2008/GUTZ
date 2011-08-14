//
//  DigitUtils.m
//  GutzTest
//
//  Created by Gullinbursti on 07/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigitUtils.h"

static DigitUtils *singleton = nil;

@implementation DigitUtils

+(DigitUtils *)singleton {
	
	if (!singleton) {
		if ([[DigitUtils class] isEqual:[self class]])
			singleton = [[DigitUtils alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	return (singleton);
}


-(int) ones:(int)value {
	return (value % 10);
}

-(int) tens:(int)value {
	int tmp = [self ones:value];
	return (((value % 100) - tmp) / 10);
}

-(int) hundreds:(int)value {
	int tmp = [self tens:value] + [self ones:value];
	return (((value % 1000) - tmp) / 100);
}

-(int) thousands:(int)value {
	int tmp = [self hundreds:value] + [self tens:value] + [self ones:value];
	return (((value % 10000) - tmp) / 1000);
}

@end
