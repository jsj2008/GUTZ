//
//  BaseScreenLayer.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseScreenLayer.h"


@implementation BaseScreenLayer

-(id) init {
	self = [super init];
	if (nil == self){
		return (nil);
	}
	
	self.isTouchEnabled = YES;
	
	//CCSprite *bg = [CCSprite spriteWithFile: @"background_static.jpg"];
	//bg.position = ccp(160,240);
	//[self addChild: bg z:0];
	
	
	return self;
}
@end

