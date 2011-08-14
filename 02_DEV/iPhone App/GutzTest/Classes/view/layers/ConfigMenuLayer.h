//
//  ConfigMenuLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "ScreenManager.h"
#import "BaseScreenLayer.h"
#import "SettingsPlistParser.h"

@interface ConfigMenuLayer : BaseScreenLayer {
	
	SettingsPlistParser *plistSettings;
	
	CCMenuItemToggle *soundsToggleButton;
	CCMenuItemToggle *pushesToggleButton;
}

-(void) procureSettings;

-(void) onBackMenu: (id) sender;
-(void) onInfo: (id) sender;
-(void) onPushesToggle: (id) sender;
-(void) onSoundsToggle: (id) sender;
@end

