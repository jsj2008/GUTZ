//
//  CreatureDataPlistParser.m
//  GutzTest
//
//  Created by Matthew Holcombe on 08.29.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreatureDataPlistParser.h"

@implementation CreatureDataPlistParser

@synthesize arrParts, arrClamps;
//@synthesize width, height;

- (id)init {
	NSLog(@"-/> %@.init%@ </-", [self class], @".()");
	
	if (!(self = [super init]))
		return (nil);
	
	return (self);
}


-(id)initWithLevel:(int)ind {
	//NSLog(@"-/> %@.%@(\"%d\") </-", [self class], @"initWithLevel", ind);
	
	if ((self = [super initWithFile:[NSString stringWithFormat:@"CreatureData_%02d", ind] path:@""])) {
		arrParts = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"parts"]];
		arrClamps = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"clamps"]];
		
		//NSLog(@"-/> %@.initWithLevel(\"%d\") [%@]\n\n\n[%@] </-", [self class], ind, arrParts, arrClamps);
	}
	
	return (self);
}

@end
