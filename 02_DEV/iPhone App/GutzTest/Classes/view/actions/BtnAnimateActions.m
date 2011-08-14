//
//  BtnAnimateActions.m
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "BtnAnimateActions.h"


@implementation BtnAnimateActions

+(void) init {
	
}

+(id) uiButtonIntro:(float)delay {
	
	CCAction *action = [CCSequence actions: 
		[CCDelayTime actionWithDuration:delay], 
		[CCScaleTo actionWithDuration:UI_INTRO_DURATION scale:1.0], 
	nil];
	
	return (action);
}


+(id) lvlButtonIntro:(float)delay {
	
	CCAction *action = [CCSequence actions: 
		[CCDelayTime actionWithDuration:delay], 
		[CCScaleTo actionWithDuration:LVL_INTRO_DURATION scale:1.0], 
	nil];
	
	return (action);
}


@end
