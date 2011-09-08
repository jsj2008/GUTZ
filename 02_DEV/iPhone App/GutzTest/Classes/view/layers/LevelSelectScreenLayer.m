//
//  LevelSelectScreenLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "GameConsts.h"

#import "CCDirector.h"

#import "AchievementsPlistParser.h"

#import "LevelSelectScreenLayer.h"
#import "LvlPagesMenuSprite.h"

#import "DigitUtils.h"
#import "RandUtils.h"

#import "SimpleAudioEngine.h"



@implementation LevelSelectScreenLayer


-(id)initFromLevel:(int)lvl {
	NSLog(@"%@.initFromStorySlides()", [self class]);
	
   if ((self = [super initWithBackround:@"bg_menu.png"])) {
		
		self.isTouchEnabled = YES;
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"buttonSound.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"levelSelect.wav"];
		
		_prevLvl = lvl;
		digitSize = CGPointMake(22, 32);
		
		[self scaffoldMenu];
	}
	
	return (self);
}


-(void)scaffoldMenu {
	
	/*
	 AchievementsPlistParser* plistAchievments = [[AchievementsPlistParser alloc] init];
	 NSLog(@"plistAchievments.dicTopLvl:[%d]", [plistAchievments arrItmEntries]);
	 
	 for (int i=0; i<[[plistAchievments arrItmEntries] count]; i++) {
	 NSLog(@"  -/> plistAchievments.arrItems[%d]=(%@) </-", i, [[plistAchievments arrItmEntries] objectAtIndex:i]);
	 }
	 */
	
	
	
	bool isLocked = NO;
	
	NSMutableArray *level_arr = [[NSMutableArray alloc] init];
	
	for (int i=0; i<kLastLvl; i++) {
		
		if (i >= (_prevLvl + 12))
			isLocked = YES;
		
		else
			isLocked = NO;
		
		
		CCMenuItemImage *btnLvlItm = [self makeBtn:i locked:isLocked];
		[level_arr addObject:btnLvlItm];
	}
	
	
	LvlPagesMenuSprite *levelMenu = [LvlPagesMenuSprite menuWithArray:level_arr cols:LVL_MENU_DIM.x rows:LVL_MENU_DIM.y position:ccp(70.0f, 360.0f) padding:CGPointMake(90.0f, 80.0f)];
	[self addChild:levelMenu z:2];
	
	CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"button_options_nonActive.png" selectedImage:@"button_options_Active.png" target:self selector:@selector(onBackMenu:)];
	CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
	backMenu.position = ccp(35, 440);
	[self addChild:backMenu z:710];
}


-(LvlBtnSprite *)makeBtn:(int)ind locked:(BOOL)isLocked {
	
	LvlBtnSprite *btnLevel;
	
	int tensDigit = [[DigitUtils singleton]tens:ind + 1];
	int onesDigit = [[DigitUtils singleton]ones:ind + 1];
	
	if (isLocked)
		btnLevel = [LvlBtnSprite itemFromNormalImage:@"buttonLocked_nonActive.png" selectedImage:@"buttonLocked_nonActive.png" target:self selector:nil];

	else {
		btnLevel = [LvlBtnSprite itemFromNormalImage:@"btn_lvlUnlocked.png" selectedImage:@"btn_lvlUnlockedActive.png" target:self selector:@selector(onLevelSelect:)];
		
		btnLevel.iLvlIndex = ind + 1;
		
		CCSprite *indHolderSprite = [CCSprite node];
		[indHolderSprite setScale:kLVL_NUM_SCALE_MULT * [[CCDirector sharedDirector]contentScaleFactor]];
		[indHolderSprite setPosition:CGPointMake(34, 50)];
		
		CCSprite *onesSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"lvlSelectDigit_%d.png", onesDigit]];
		
		if (tensDigit > 0) {
			CCSprite *tensSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"lvlSelectDigit_%d.png", tensDigit]];
			[tensSprite setPosition:CGPointMake(-17, 0)];
			[onesSprite setPosition:CGPointMake(17, 0)];
			
			[indHolderSprite addChild:tensSprite];
		}
		
		[indHolderSprite addChild:onesSprite];
		[btnLevel addChild:indHolderSprite];
		
		int xPos = 16;
		int yPos = 27;
		
		for (int i=0; i<3; i++) {
			
			if (i == 1)
				yPos = 25;
			
			else
				yPos = 27;
			
			CCSprite *star = [CCSprite spriteWithFile:@"levelStar_Left.png"];
			[star setPosition:CGPointMake(xPos, yPos)];
			
			xPos += 18;
			
			[btnLevel addChild:star];
		}
	}
	
	return (btnLevel);
}




-(void) onBackMenu:(id)sender {
	NSLog(@"LevelSelectScreenLayer.onBackMenu()");
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	[ScreenManager goMenu];
}

-(void) onLevelSelect:(id)sender {
	NSLog(@"LevelSelectScreenLayer.onLevelSelect(%d)", ((LvlBtnSprite *)sender).iLvlIndex);
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	
	int indLvl = ((LvlBtnSprite *)sender).iLvlIndex;
	
	if (indLvl > kLastLvl)
		indLvl = 1;
	
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
	
	if (indLvl == 1) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_play-02.mp3" loop:YES];
		[ScreenManager goLevelStorySlides:1 slideCount:5 nextLvl:1];
	
	} else {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_play-01.mp3" loop:YES];
		[ScreenManager goPlay:indLvl];
	}
}

@end
