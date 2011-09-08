//
//	ScreenManager.m
//	GutzTest
//
//	Created by Gullinbursti on 06/16/11.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScreenManager.h"
#import "SimpleAudioEngine.h"

#import "GameConfig.h"

#define TRANSITION_DURATION (1.2f)

static int sceneIdx=0;

static NSString *transitions[] = {
	@"FlipYDownOver",
	@"FadeWhiteTransition",
	@"ZoomFlipXLeftOver",
};

Class nextTransition() {	
	// HACK: else NSClassFromString will fail
	//[CCRadialCCWTransition node];
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return (c);
}

@interface ScreenManager ()
+(void)go:(CCLayer *)layer;
+(CCScene *)wrap:(CCLayer *)layer;
@end


@implementation ScreenManager

+(void)goMenu {
	NSLog(@"ScreenManager.goMenu()");
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger isSFX = [prefs integerForKey:@"enable_sfx"];
	
	/*
	if (!isSFX) {
		isSFX = YES;
		
		[prefs setInteger:isSFX forKey:@"enable_sfx"];
		[prefs synchronize];
	}
	*/
	
	[[SimpleAudioEngine sharedEngine] setMute:!(BOOL)isSFX];
	
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.33f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"bootUp.wav"];
	
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.875f];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_menu-01.mp3" loop:YES];
	
	CCLayer *layer = [[MainMenuScreenLayer alloc] init];
	[ScreenManager go:layer];
}

+(void)goConfig {
	NSLog(@"ScreenManager.goConfig()");
		
	CCLayer *layer = [[ConfigMenuLayer alloc] init];
	[ScreenManager go:layer];
}

+(void)goLevelSelect:(int)lvl {
	NSLog(@"ScreenManager.goLevelSelect(%d)", lvl);
	
	CCLayer *layer = [[LevelSelectScreenLayer alloc] initFromLevel:lvl];
	[ScreenManager go:layer];
}

+(void)goPlay:(int)lvl {
	NSLog(@"ScreenManager.goPlay(%d)", lvl);
	
	CCLayer *layer = [[PlayScreenLayer alloc] initWithLevel:lvl];
	//CCLayer *layer = [[PlayScreenLayer alloc] init];
	[ScreenManager go:layer];
}


+(void)goLevelComplete:(int)lvl withBonus:(BOOL)bonus {
	NSLog(@"ScreenManager.goLevelComplete(%d)", (int)bonus);
		
	CCLayer *layer = [[LevelCompleteScreenLayer alloc] initWithLevel:lvl withBonus:bonus];
	[ScreenManager go:layer];
}



+(void)goLevelStorySlides:(int)ind slideCount:(int)cnt nextLvl:(int)lvl {
	NSLog(@"ScreenManager.goLevelStorySlides(%d, %d)", ind, cnt);
	
	CCLayer *layer = [[StorySlidesLayer alloc] initWithStoryIndex:ind slideCount:cnt nextLvl:lvl];
	[ScreenManager go:layer];
}

+(void)goGameOver {
	NSLog(@"ScreenManager.goGameOver()");
		
	//CCLayer *layer = [GameOverLayer node];
	//[ScreenManager go: layer];
}


+(void)goFinaleAct {
	NSLog(@"ScreenManager.goFinaleAct()");
		
	//CCLayer *layer = [GameOverLayer node];
	//[ScreenManager go: layer];
}

+(void)go:(CCLayer *)layer {
	//NSLog(@"ScreenManager.go("+layer+")");
		
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [ScreenManager wrap:layer];
	
	//Class transition = nextTransition();
	
	if ([director runningScene]) {
				[director replaceScene:newScene];
		//[director replaceScene:[transition transitionWithDuration:TRANSITION_DURATION scene:newScene]];
		
	} else
		[director runWithScene:newScene];		
}

+(CCScene *)wrap:(CCLayer *)layer {
	NSLog(@"ScreenManager.wrap()");
		
	CCScene *newScene = [CCScene node];
	[newScene addChild:layer];
	
	return (newScene);
}

@end

