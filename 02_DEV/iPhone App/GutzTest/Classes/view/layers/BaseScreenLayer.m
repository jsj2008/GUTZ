//
//  BaseScreenLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseScreenLayer.h"

@implementation BaseScreenLayer

- (id)init {
	
	if ((self = [super init])) {
		self.isTouchEnabled = YES;
	}
	
	return (self);
}

- (id)initWithBackround:(NSString *)asset {
	
	if ((self = [super init])) {
	
		CGPoint ptCenterPos = CGPointMake([[CCDirector sharedDirector]winSize].width * 0.5f, [[CCDirector sharedDirector]winSize].height * 0.5f);
		
		CCSprite *sprite = [CCSprite spriteWithFile: asset];
		sprite.position = ccp(ptCenterPos.x, ptCenterPos.y);
		[self addChild:sprite z:0];
	}
	
	return (self);
}


- (id)initWithBackround:(NSString *)asset position:(CGPoint)pos {
	
	if ((self = [super init])) {
	
		CCSprite *sprite = [CCSprite spriteWithFile: asset];
		sprite.position = ccp(pos.x, pos.y);
		[self addChild:sprite z:0];
	}
	
	return (self);
}


@end
