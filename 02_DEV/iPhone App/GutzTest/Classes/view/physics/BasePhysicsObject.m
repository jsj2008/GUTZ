//
//  BasePhysicsObject.m
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsObject.h"



@implementation BasePhysicsObject

@synthesize chipmunkObjects;

-(id)init {
	
	if ((self = [super init])) {
		
		chipmunkObjects = [NSMutableSet set];
	}
	
	
	return (self);
}



- (void)dealloc {
	[_body release];
	[_shape release];
	
	chipmunkObjects = nil;
	
	[super dealloc];
}


@end
