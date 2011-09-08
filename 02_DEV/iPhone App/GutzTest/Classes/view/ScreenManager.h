//
//  ScreenManager.h
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "MainMenuScreenLayer.h"
#import "PlayScreenLayer.h"
#import "ConfigMenuLayer.h"
#import "LevelSelectScreenLayer.h"
#import "LevelCompleteScreenLayer.h"
#import "StorySlidesLayer.h"

@interface ScreenManager : NSObject {
}

+(void) goMenu;
+(void) goPlay:(int)lvl;
+(void) goConfig;
+(void) goLevelSelect:(int)lvl;
+(void) goLevelComplete:(int)lvl withBonus:(BOOL)bonus;
+(void) goLevelStorySlides:(int)ind slideCount:(int)cnt nextLvl:(int)lvl;
+(void) goGameOver;

@end
