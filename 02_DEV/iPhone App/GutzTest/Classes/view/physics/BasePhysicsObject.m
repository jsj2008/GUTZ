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
@synthesize _body;

-(id)init {
	
	if ((self = [super init])) {
		
		set = [NSMutableSet set];
		chipmunkObjects = [NSMutableSet set];
	}
	
	return (self);
}


-(void)spaceRef:(ChipmunkSpace *)space {
	_space = space;
}

-(void)layerRef:(CCLayer *)layer {
	_layer = layer;
}



-(void)dealloc {
	[_body removeFromSpace:_space];
	[_body release];
	
	[_shape removeFromSpace:_space];
	[_shape release];
	
	[_space removeBaseObjects:chipmunkObjects];
	[chipmunkObjects release];

	_body = nil;
	_shape = nil;
	set = nil;
	
	[super dealloc];
}


@end
