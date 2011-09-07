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
#import "ChipmunkDebugNode.h"

#import "DigitUtils.h"
#import "RandUtils.h"

#import "SimpleAudioEngine.h"


static NSString *borderType = @"borderType";


@implementation LevelSelectScreenLayer


-(id) init {
	NSLog(@"%@.init()", [self class]);
   CGSize wins = [[CCDirector sharedDirector] winSize];
	
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"buttonSound.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"levelSelect.wav"];
	
	//self = [super init];
	self = [super initWithBackround:@"bg_menu.png"];
	
	//CCSprite *bg = [CCSprite spriteWithFile: @"background_default.jpg"];
	//bg.position = ccp(160, 240);
	//[self addChild: bg z:0];
	
	
	digitSize = CGPointMake(22, 32);
	
	
	cpInitChipmunk();
	
	_space = [[ChipmunkSpace alloc] init];
	_space.gravity = cpv(0, 0);
	
	//[self addChild:[ChipmunkDebugNode debugNodeForSpace:_space]];
	
	CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
	[_space addBounds:rect thickness:532 elasticity:1 friction:1 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	/*
	_accBlob1 = [[JellyBlob alloc] initWithPos:cpv(164, 100) radius:32 count:16];
	[_space add:_accBlob1];
	
	_accBlob2 = [[JellyBlob alloc] initWithPos:cpv(160, 120) radius:16 count:8];
	[_space add:_accBlob2];
	
	_accBlob3 = [[JellyBlob alloc] initWithPos:cpv(140, 210) radius:24 count:12];
	[_space add:_accBlob3];
	
	_accBlob4 = [[JellyBlob alloc] initWithPos:cpv(140, 332) radius:8 count:8];
	[_space add:_accBlob4];
	
	[self schedule:@selector(physicsStepper:)];
	[self schedule:@selector(mobWiggler:) interval:0.25f + (CCRANDOM_0_1() * 0.125f)];
	 */
	/*
	 AchievementsPlistParser* plistAchievments = [[AchievementsPlistParser alloc] init];
	 NSLog(@"plistAchievments.dicTopLvl:[%d]", [plistAchievments arrItmEntries]);
	 
	 for (int i=0; i<[[plistAchievments arrItmEntries] count]; i++) {
	 NSLog(@"  -/> plistAchievments.arrItems[%d]=(%@) </-", i, [[plistAchievments arrItmEntries] objectAtIndex:i]);
	 }
	 */
	
	
	self.isTouchEnabled = YES;
	
	//digitBatchSprite = [CCSpriteBatchNode batchNodeWithFile:@"digitsLvlSelect_spritemap.png" capacity:100];
	//[self addChild:digitBatchSprite];

	bool isLocked = NO;
	
	
	NSMutableArray *level_arr = [[NSMutableArray alloc] init];
	
	for (int i=0; i<12; i++) {
		
		if (i >= kLastLevel)
			isLocked = YES;
		
		else
			isLocked = NO;
		
		
		CCMenuItemImage *btnLvlItm = [self makeBtn:i locked:isLocked];
		
		
		[level_arr addObject:btnLvlItm];
	}
	
	
	LvlPagesMenuSprite *levelMenu = [LvlPagesMenuSprite menuWithArray:level_arr cols:LVL_MENU_DIM.x rows:LVL_MENU_DIM.y position:CGPointMake(70.f, 380.f) padding:CGPointMake(90.f, 80.f)];
	[self addChild:levelMenu z:2];
	
	if (kShowDebugMenus) {
		CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"button_options_nonActive.png" selectedImage:@"button_options_Active.png" target:self selector:@selector(onBackMenu:)];
		CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
		backMenu.position = ccp(35, 440);
		[self addChild:backMenu z:710];
	}
	
	return (self);
}

-(LvlBtnSprite *) makeBtn:(int)ind locked:(BOOL)isLocked {
	
	LvlBtnSprite *btnLevel;
	
	int tensDigit = [[DigitUtils singleton]tens:ind + 1];
	int onesDigit = [[DigitUtils singleton]ones:ind + 1];
	
	//int row = ind / 3;
	//int col = ind % 3;
	
	if (isLocked) {
		//btnLevel = [[LvlBtnSprite alloc] initWithLevelIndex:ind locked:isLocked normal:@"buttonLocked_nonActive.png" selected:@"buttonLocked_nonActive.png"];
		btnLevel = [LvlBtnSprite itemFromNormalImage:@"buttonLocked_nonActive.png" selectedImage:@"buttonLocked_nonActive.png" target:self selector:nil];

	} else {
		//btnLevel = [[LvlBtnSprite alloc] initWithLevelIndex:ind locked:isLocked normal:@"btn_lvlUnlocked.png" selected:@"btn_lvlUnlockedActive.png"];
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
	
	//[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.25f];
	//[[SimpleAudioEngine sharedEngine] playEffect:@"levelSelect.wav"];
	
	NSString *strBGM = [NSString stringWithFormat:@"bgm_play-0%d.mp3", (int)(CCRANDOM_0_1() + 1)];
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5f];
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:strBGM loop:YES];
	
	
	[ScreenManager goPlay:((LvlBtnSprite *)sender).iLvlIndex];
}


+(void) onPageChange:(int)ind {
	NSLog(@"LevelSelectScreenLayer.onPageChange(%d)", ind);
}


-(void) physicsStepper: (ccTime) dt {
	//NSLog(@"PlayScreenLayer.physicsStepper(%0.000000f)", [[CCDirector sharedDirector] getFPS]);
	
	[_space step:1.0 / 60.0];
}

-(void) draw {
	//NSLog(@"///////[DRAW]////////");
	
	[super draw];
	
	
	[_accBlob1 draw];
	[_accBlob2 draw];
	[_accBlob3 draw];
	[_accBlob4 draw];
	
	
	
	
	//for (int i=0; i<[arrGibs count]; i++) {
	//	ChipmunkShape *shape = (ChipmunkShape *)[arrGibs objectAtIndex:i];
	//	ccDrawCircle(shape.body.pos, 3, 360, 4, NO);
	//}
	
}


-(void) mobWiggler:(id)sender {
	
	cpFloat maxForce = 4.0f;
	
	cpFloat rndForce = CCRANDOM_0_1() * maxForce;
	
	
	switch (((int)CCRANDOM_0_1() * 4)) {
		case 0:
			[_accBlob1 wiggleWithForce:[[RandUtils singleton]randIndex:32] force:rndForce];
			break;
			
		case 1:
			[_accBlob2 wiggleWithForce:[[RandUtils singleton]randIndex:16] force:rndForce];
			break;
			
		case 2:
			[_accBlob3 wiggleWithForce:[[RandUtils singleton]randIndex:24] force:rndForce];
			break;
			
		case 3:
			[_accBlob4 wiggleWithForce:[[RandUtils singleton]randIndex:8] force:rndForce];
			break;
	}
	
}
@end
