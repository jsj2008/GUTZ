//
//  BtnAnimateActions.h
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"


#define UI_INTRO_DELAY 0.2f
#define UI_INTRO_DURATION 0.33f

#define LVL_INTRO_DELAY 0.1f
#define LVL_INTRO_DURATION 0.2f




@interface BtnAnimateActions : NSObject {
	CCAction *uiBtn_act;
}

+(void) init;

+(id) uiButtonIntro:(float)delay;
+(id) lvlButtonIntro:(float)delay;

@end
