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

@interface ScreenManager : NSObject {
}

+(void) goMenu;
+(void) goPlay:(int)lvl;
+(void) goConfig;
+(void) goLevelSelect;
+(void) goLevelComplete:(int)lvl withBonus:(BOOL)bonus;
+(void) goGameOver;

@end
