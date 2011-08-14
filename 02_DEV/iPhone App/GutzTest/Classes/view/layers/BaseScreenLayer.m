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
	
	self = [super init];
	
	if (nil == self)
		return (nil);
	
	self.isTouchEnabled = YES;
	
	//CCSprite *bg = [CCSprite spriteWithFile: @"background_static.jpg"];
	//bg.position = ccp(160,240);
	//[self addChild: bg z:0];
	
	
	return (self);
}

- (id)initWithBackround:(NSString *)asset {
	
	self = [super init];
	
	if (nil == self)
		return (nil);
	
	
	CGPoint ptCenterPos = CGPointMake([[CCDirector sharedDirector]winSize].width * 0.5f, [[CCDirector sharedDirector]winSize].height * 0.5f);
	
	CCSprite *sprite = [CCSprite spriteWithFile: asset];
	sprite.position = ccp(ptCenterPos.x, ptCenterPos.y);
	[self addChild:sprite z:0];
	
	return (self);
}


- (id)initWithBackround:(NSString *)asset position:(CGPoint)pos {
	
	self = [super init];
	
	if (nil == self)
		return (nil);
	
	CCSprite *sprite = [CCSprite spriteWithFile: asset];
	sprite.position = ccp(pos.x, pos.y);
	[self addChild:sprite z:0];
	
	return (self);
}

//-(id)initWithColor:(ccColor4B)color {
//	self = [super initWithColor:color];
//	
//	if (nil == self)
//		return (nil);
//	
//	return (self);
//}


@end
