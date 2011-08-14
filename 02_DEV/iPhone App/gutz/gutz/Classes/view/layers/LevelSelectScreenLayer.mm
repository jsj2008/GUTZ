//
//  LevelSelectScreenLayer.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCDirector.h"

#import "AchievementsPlistParser.h"

#import "LevelSelectScreenLayer.h"
#import "LvlPagesMenuSprite.h"

#import "DigitUtils.h"



@implementation LevelSelectScreenLayer


-(id) init {
    NSLog(@"LevelSelectScreenLayer.init()");
    
	self = [super init];
    
    CCSprite *bg = [CCSprite spriteWithFile: @"background_default.jpg"];
	bg.position = ccp(160, 240);
    [self addChild: bg z:0];
	
	
	digitSize = CGPointMake(22, 32);
	
	
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
    
    for (int i=0; i<36; i++) {
        
		if (i >= 7)
            isLocked = YES;
        
		else
            isLocked = NO;
        
		
		CCMenuItemImage *btnLvlItm = [self makeBtn:i locked:isLocked];
		
		
        [level_arr addObject:btnLvlItm];
    }
    
    
    LvlPagesMenuSprite *levelMenu = [LvlPagesMenuSprite menuWithArray:level_arr cols:3 rows:4 position:CGPointMake(70.f, 380.f) padding:CGPointMake(90.f, 80.f)];
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
	
	
	if (isLocked)
		btnLevel = [LvlBtnSprite itemFromNormalImage:@"buttonLocked_nonActive.png" selectedImage:@"buttonLocked_nonActive.png" target:self selector:nil];
	
	else {
		
		btnLevel = [LvlBtnSprite itemFromNormalImage:@"buttonUnlocked_nonActive.png" selectedImage:@"buttonUnlocked_Active.png" target:self selector:@selector(onLevelSelect:)];
		
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
    
    [ScreenManager goMenu];
}

-(void) onLevelSelect:(id)sender {
    NSLog(@"LevelSelectScreenLayer.onLevelSelect()");
    
    [ScreenManager goPlay];
}


+(void) onPageChange:(int)ind {
    NSLog(@"LevelSelectScreenLayer.onPageChange(%d)", ind);
}
@end
