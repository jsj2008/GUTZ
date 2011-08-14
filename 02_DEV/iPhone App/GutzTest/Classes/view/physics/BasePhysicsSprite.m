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


-(id)init {
	
	if ((self = [super init])) {
		
	}
	
	return (self);
}

- (void)updatePosition {
	
	[_sprite setPosition:_body.pos];
	
}

- (void)dealloc {
	[_sprite release];
	
	[super dealloc];
}

@end
