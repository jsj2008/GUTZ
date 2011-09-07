//
//  MainMenuScreenLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "GameConfig.h"
#import "GameConsts.h"
#import "MainMenuScreenLayer.h"
#import "BtnAnimateActions.h"

#import "DigitUtils.h"
#import "RandUtils.h"

#import "SimpleAudioEngine.h"


@implementation MainMenuScreenLayer

-(id) init {
    NSLog(@"MainMenuScreenLayer.init()");
   
	if ((self = [super initWithBackround:MENU_BG_ASSET])) {
		
		float delayTime = 0.3f;
		
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.95];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"buttonSound.wav"];
		
		
		CCMenuItemImage *btnStartNew = [CCMenuItemImage itemFromNormalImage:@"btn_play.png" selectedImage:@"btn_playActive.png" target:self selector:@selector(onNewGame:)];
		CCMenuItemImage *btnStore = [CCMenuItemImage itemFromNormalImage:@"btn_store.png" selectedImage:@"btn_storeActive.png" target:self selector:@selector(onStore:)];
		CCMenuItemImage *btnAbout = [CCMenuItemImage itemFromNormalImage:@"btn_about.png" selectedImage:@"btn_aboutActive.png" target:self selector:@selector(onAbout:)];
		CCMenuItemImage *btnSettings = [CCMenuItemImage itemFromNormalImage:@"btn_settings.png" selectedImage:@"btn_SettingsActive.png" target:self selector:@selector(onConfig:)];
		 
		CCMenu *configMenu = [CCMenu menuWithItems:btnSettings, nil];
		configMenu.position = ccp(273, 440);
		[self addChild:configMenu z:2];
		 
		CCMenu *startMenu = [CCMenu menuWithItems:btnStartNew, btnStore, btnAbout, nil];
		
		for (CCSprite *each in [startMenu children]) {
			each.scaleX = 0.0f;
			each.scaleY = 0.0f;
			
			CCAction *action = [
					CCSequence actions: [CCDelayTime actionWithDuration: delayTime], 
					[CCScaleTo actionWithDuration:0.5F scale:1.0], 
				nil];
			
			delayTime += 0.2f;
			[each runAction: action];
		}
		
		startMenu.position = ccp(160, 200);
		[startMenu alignItemsVerticallyWithPadding: 120.0f];
		[self addChild:startMenu z: 2];
	
	}
	
	return (self);
}


#pragma mark MenuActions

-(void) onNewGame:(id)sender{ 
     NSLog(@"MainMenuScreenLayer.onNewGame()");
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
    [ScreenManager goLevelSelect];
}

-(void) onStore:(id)sender {
	NSLog(@"MainMenuScreenLayer.onStore()");
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	//[ScreenManager goConfig];
}

-(void) onAbout:(id)sender {
	NSLog(@"MainMenuScreenLayer.onAbout()");
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	//[ScreenManager goConfig];
}

-(void) onConfig:(id)sender {
    NSLog(@"MainMenuScreenLayer.onConfig()");
	
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	
	[ScreenManager goConfig];
}


-(void) dealloc {
	[super dealloc];	
}

@end



/*
 CCLabelTTF *titleLeft = [CCLabelTTF labelWithString:@"Menu " fontName:@"Marker Felt" fontSize:48];
 CCAction *titleLeftAction = [CCSequence actions: [CCDelayTime actionWithDuration: delayTime], [CCEaseBackOut actionWithAction: [CCMoveTo actionWithDuration: 1.0 position:ccp(80,345)]], nil];
 [self addChild: titleLeft];
 [titleLeft runAction: titleLeftAction];
*/