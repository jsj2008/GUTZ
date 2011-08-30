//
//  CreatureDataPlistParser.m
//  GutzTest
//
//  Created by Matthew Holcombe on 08.29.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreatureDataPlistParser.h"

@implementation CreatureDataPlistParser

@synthesize arrCircles, arrJoints;
@synthesize width, height;

- (id)init {
	NSLog(@"-/> %@.init%@ </-", [self class], @".()");
	
	if (!(self = [super init]))
		return (nil);
	
	return (self);
}


-(id)initWithLevel:(int)ind {
	NSLog(@"-/> %@.%@(\"%d\") </-", [self class], @"initWithLevel", ind);
	
	if ((self = [super initWithFile:[NSString stringWithFormat:@"CreatureData_0%d", ind] path:@""])) {
		
		arrCircles = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"circles"]];
		arrJoints = [[NSArray alloc] initWithArray:[[super dicTopLvl] objectForKey:@"joints"]];
		
		width = [[(NSDictionary *)[[super dicTopLvl] objectForKey:@"size"] objectForKey:@"width"] intValue];
		height = [[(NSDictionary *)[[super dicTopLvl] objectForKey:@"size"] objectForKey:@"height"] intValue];
	}
	
	return (self);
}

@end
