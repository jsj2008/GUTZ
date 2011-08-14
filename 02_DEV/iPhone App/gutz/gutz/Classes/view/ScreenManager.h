//
//  ScreenManager.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
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
+(void) goPlay;
+(void) goConfig;
+(void) goLevelSelect;
+(void) goLevelComplete;
+(void) goGameOver;

@end
