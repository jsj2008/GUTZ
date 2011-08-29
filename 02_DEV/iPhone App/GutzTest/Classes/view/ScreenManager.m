//
//  ScreenManager.m
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScreenManager.h"
#import "SimpleAudioEngine.h"

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
	return c;
}

@interface ScreenManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end


@implementation ScreenManager

+(void) goMenu {
    NSLog(@"ScreenManager.goMenu()");
    
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.67];
	[[SimpleAudioEngine sharedEngine] playEffect:@"bootUp.wav"];
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.75];
	[[SimpleAudioEngine sharedEngine] playEffect:@"menuGUTZ.wav"];
	
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.5f];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"UI_loop.wav" loop:YES];
	
	CCLayer *layer = [[MainMenuScreenLayer alloc] init];
	[ScreenManager go:layer];
}

+(void) goConfig {
    NSLog(@"ScreenManager.goConfig()");
    
	CCLayer *layer = [[ConfigMenuLayer alloc] init];
	[ScreenManager go:layer];
}

+(void) goLevelSelect {
    NSLog(@"ScreenManager.goLevelSelect()");
    
	CCLayer *layer = [[LevelSelectScreenLayer alloc] init];
	[ScreenManager go:layer];
}

+(void) goPlay:(int)lvl {
    NSLog(@"ScreenManager.goPlay()");
    
	CCLayer *layer = [[PlayScreenLayer alloc] initWithLevel:lvl];
	//CCLayer *layer = [[PlayScreenLayer alloc] init];
	[ScreenManager go:layer];
}


+(void) goLevelComplete:(int)lvl {
    NSLog(@"ScreenManager.goLevelComplete()");
    
	CCLayer *layer = [[LevelCompleteScreenLayer alloc] initWithLevel:lvl];
	[ScreenManager go:layer];
}

+(void) goGameOver {
    NSLog(@"ScreenManager.goGameOver()");
    
	//CCLayer *layer = [GameOverLayer node];
	//[ScreenManager go: layer];
}


+(void) goFinaleAct {
    NSLog(@"ScreenManager.goFinaleAct()");
    
	//CCLayer *layer = [GameOverLayer node];
	//[ScreenManager go: layer];
}

+(void) go: (CCLayer *) layer {
    //NSLog(@"ScreenManager.go("+layer+")");
    
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [ScreenManager wrap:layer];
	
	//Class transition = nextTransition();
	
	if ([director runningScene]) {
        [director replaceScene:newScene];
		//[director replaceScene:[transition transitionWithDuration:TRANSITION_DURATION scene:newScene]];
		
	}else {
		[director runWithScene:newScene];		
	}
}

+(CCScene *) wrap:(CCLayer *)layer {
    NSLog(@"ScreenManager.wrap()");
    
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}

@end

