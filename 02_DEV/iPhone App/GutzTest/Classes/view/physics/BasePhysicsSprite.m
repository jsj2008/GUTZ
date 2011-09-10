//
//  BasePhysicsSprite.m
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"


@implementation BasePhysicsSprite

@synthesize _sprite;


-(id)initAtPos:(cpVect)pos {

	if ((self = [super init])) {
		_ptPos = pos;
	}
	
	
	return (self);
}


-(id)init {
	
	if ((self = [super init])) {
		
	}
	
	return (self);
}

-(void)updPos {
	
	[_sprite setPosition:_body.pos];
	
}

-(void)dealloc {
	[_sprite release];
	
	[super dealloc];
}

@end
