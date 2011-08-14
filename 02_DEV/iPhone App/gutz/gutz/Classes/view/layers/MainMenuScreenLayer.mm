//
//  MainMenuScreenLayer.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameConfig.h"
#import "MainMenuScreenLayer.h"


#import "DigitUtils.h"

@implementation MainMenuScreenLayer

-(id) init {
    NSLog(@"MainMenuScreenLayer.init()");
    
	self = [super init];
    
    CCSprite *bg = [CCSprite spriteWithFile: @"background_main.jpg"];
	bg.position = ccp(160, 240);
    [self addChild: bg z:0];
    
	
	float delayTime = 0.3f;
	
	CCMenuItemImage *startNew = [CCMenuItemImage itemFromNormalImage:@"playButton_nonActive.png" selectedImage:@"playButton_Active.png" target:self selector:@selector(onNewGame:)];
	CCMenuItemImage *config = [CCMenuItemImage itemFromNormalImage:@"optionsButton_nonActive.png" selectedImage:@"optionsButton_Active.png" target:self selector:@selector(onConfig:)];
    
    CCMenu *configMenu = [CCMenu menuWithItems:config, nil];
    configMenu.position = ccp(273, 440);
    [self addChild:configMenu z:2];
    
	CCMenu *startMenu = [CCMenu menuWithItems:startNew, nil];
	
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
	
	startMenu.position = ccp(160, 90);
	[startMenu alignItemsVerticallyWithPadding: 120.0f];
	[self addChild:startMenu z: 2];
	
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	return self;
}

-(void) onNewGame:(id)sender{ 
	NSLog(@"MainMenuScreenLayer.onNewGame()");
    [ScreenManager goLevelSelect];
}

-(void) onConfig:(id)sender {
    NSLog(@"MainMenuScreenLayer.onConfig()");
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