//
//  GameOverLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelCompleteScreenLayer.h"
#import "AchievementsPlistParser.h"

#import "RandUtils.h"
#import "SimpleAudioEngine.h"

#import "GameConsts.h"



@implementation LevelCompleteScreenLayer

-(id)initWithLevel:(int)lvl {
	
	indLvl = lvl;
	
	return ([self init]);
}


-(id)initWithLevel:(int)lvl withBonus:(BOOL)bonus {
	NSLog(@"%@.initWithLevel(%d)", [self class], (int)bonus);
	
	indLvl = lvl;
	_isBonus = bonus;
	
	
	if (_isBonus) {
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_3stars_fanfare.mp3"];
	}
	
	return ([self init]);
}

-(id) init {
	NSLog(@"LevelCompleteScreenLayer.init()");
	
	if ((self = [super initWithBackround:MENU_BG_ASSET])) {
		
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.85f];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"buttonSound.wav"];
			
		NSDate *unixTime = [[NSDate alloc] initWithTimeIntervalSince1970:0];
		NSLog(@":::::::::::::[%d]:::::::::::::", (int)unixTime);
		
		
		/*
		 // start time
		 NSDate *startTime = [[NSDate date] retain];
		 
		 ...
		 
		 // At a later time
		 double timeElapsed = -[startTime timeIntervalSinceNow] *  1000;  // msec elapsed
		 */
		
		float delayTime = 0.0f;
		
		CCSprite *gSprite = [CCSprite spriteWithFile:@"letter_g.png"];
		[gSprite setPosition:ccp(60, 380)];
		[gSprite setScale:0.0f];
		[self addChild:gSprite];
		
		CCSprite *rSprite = [CCSprite spriteWithFile:@"letter_r.png"];
		[rSprite setScale:0.0f];
		[rSprite setPosition:ccp(100, 380)];
		[self addChild:rSprite];
		
		CCSprite *eSprite = [CCSprite spriteWithFile:@"letter_e.png"];
		[eSprite setScale:0.0f];
		[eSprite setPosition:ccp(140, 380)];
		[self addChild:eSprite];
		
		CCSprite *aSprite = [CCSprite spriteWithFile:@"letter_a.png"];
		[aSprite setScale:0.0f];
		[aSprite setPosition:ccp(180, 380)];
		[self addChild:aSprite];
		
		CCSprite *tSprite = [CCSprite spriteWithFile:@"letter_t.png"];
		[tSprite setScale:0.0f];
		[tSprite setPosition:ccp(220, 380)];
		[self addChild:tSprite];
		
		CCSprite *xSprite = [CCSprite spriteWithFile:@"letter_exPoint.png"];
		[xSprite setScale:0.0f];
		[xSprite setPosition:ccp(250, 380)];
		[self addChild:xSprite];
		
		
		arrLetterSprite = [[NSMutableArray alloc] initWithObjects:gSprite, rSprite, eSprite, aSprite, tSprite, xSprite, nil];
		
		
		for (int i=0; i<[arrLetterSprite count]; i++) {
			
			CCSprite *sprite = [arrLetterSprite objectAtIndex:i];
			CCAction *action = [CCSequence actions:[CCDelayTime actionWithDuration: delayTime], [CCScaleTo actionWithDuration:0.1f scale:1.0], nil];
			
			delayTime += 0.025f;
			delayTime *= 0.98;
			[sprite runAction: action];
		}
		
		[self performSelector:@selector(letterWiggleProvoker:) withObject:nil afterDelay:0.2];
		
		
		CGPoint ptStarPos = CGPointMake(-80 + (((int)!_isBonus) * 40), 0);
		
		CCSprite *starHolder = [CCSprite node];
		[starHolder setPosition:ccp(160, 320)];
		[self addChild:starHolder];
		
		CCSprite *star1 = [CCSprite spriteWithFile:@"lvlstar_big.png"];
		[star1 setScale:0.0f];
		[star1 setPosition:ccp(ptStarPos.x, ptStarPos.y)];
		[starHolder addChild:star1];
		ptStarPos.x += 80;
		
		CCSprite *star2 = [CCSprite spriteWithFile:@"lvlstar_big.png"];
		[star2 setPosition:ccp(ptStarPos.x, ptStarPos.y)];
		[star2 setScale:0.0f];
		[starHolder addChild:star2];
		ptStarPos.x += 80;
		
		if (_isBonus) {
			
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.85f];
			[[SimpleAudioEngine sharedEngine] playEffect:@"sfx_3stars_fanfare.mp3"];
			
			CCSprite *star3 = [CCSprite spriteWithFile:@"lvlstar_big.png"];
			[star3 setPosition:ccp(ptStarPos.x, ptStarPos.y)];
			[star3 setScale:0.0f];
			[starHolder addChild:star3];
			
			arrStarSprite = [[NSMutableArray alloc] initWithObjects:star1, star2, star3, nil];
		
		} else
			arrStarSprite = [[NSMutableArray alloc] initWithObjects:star1, star2, nil]; 
		
		delayTime += 0.2f;
		for (int i=0; i<[arrStarSprite count]; i++) {
			CCSprite *sprite = [arrStarSprite objectAtIndex:i];
			CCAction *action = [CCSequence actions:[CCDelayTime actionWithDuration: delayTime], [CCScaleTo actionWithDuration:0.1f scale:1.0], nil];
			
			delayTime += 0.05f;
			[sprite runAction: action];
		}
		
		[self performSelector:@selector(starWiggleProvoker:) withObject:nil afterDelay:0.5];
		
		CCMenuItemImage *btnReplayLevel = [CCMenuItemImage itemFromNormalImage:@"btn_replay.png" selectedImage:@"btn_replayActive.png" target:self selector:@selector(onReplayLevel:)];
		//[btnReplayLevel setScale:0.0f];
		
		CCMenuItemImage *btnNextLevel = [CCMenuItemImage itemFromNormalImage:@"btn_next.png" selectedImage:@"btn_nextActive.png" target:self selector:@selector(onNextLevel:)];
		//[btnNextLevel setScale:0.0f];
		
		CCMenu *menu = [CCMenu menuWithItems:btnReplayLevel, btnNextLevel, nil];
		//CCAction *action = [CCSequence actions:[CCDelayTime actionWithDuration:delayTime], [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil];
		
		CCAction *action = [CCSequence actions:[CCMoveBy actionWithDuration:0.2f position:ccp(0, 160)], nil];
		
		//[btnReplayLevel runAction:[action copy]];
		//[btnNextLevel runAction:[action copy]];
		
		menu.position = ccp(160, 0);
		[menu alignItemsVerticallyWithPadding:50.0f];
		[menu runAction:action];
		
		//[menu alignItemsVerticallyWithPadding:115.0f];
		[self addChild:menu z:2];
	}
		
	return (self);
}


-(void)letterWiggleProvoker:(id)sender {
	[self schedule:@selector(letterWiggler:) interval:0.1f];
}


-(void)starWiggleProvoker:(id)sender {
	[self schedule:@selector(starWiggler:) interval:0.15f];
}

-(void) onNextLevel:(id)sender { 
	NSLog(@"LevelCompleteScreenLayer.onNextLevel()");
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.95f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	
	[ScreenManager goPlay:++indLvl];
}

-(void) onReplayLevel:(id)sender { 
	NSLog(@"LevelCompleteScreenLayer.onReplayLevel()");
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.95f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	[ScreenManager goPlay:indLvl];
}

-(void) onBackMenu:(id)sender {
	NSLog(@"LevelCompleteScreenLayer.onBackMenu()");
	
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.95f];
	[[SimpleAudioEngine sharedEngine] playEffect:@"buttonSound.wav"];
	[ScreenManager goMenu];
}


-(void)letterWiggler:(id)sender {
	
	cpVect pos = cpv(65, 380);
	
	for (int i=0; i<[arrLetterSprite count]; i++) {
		
		CCSprite *sprite = [arrLetterSprite objectAtIndex:i];
		[sprite setPosition:cpvadd(pos, cpv((CCRANDOM_0_1() * 2) - 1, (CCRANDOM_0_1() * 2) - 1))];
		
		[sprite runAction:[CCScaleTo actionWithDuration:0.1f scale:(CCRANDOM_0_1() * 0.25) + 0.875]];
		pos = cpvadd(pos, cpv(40, 0));
	}
}



-(void)starWiggler:(id)sender {
	
	cpVect pos = cpv(-80 + ((int)(!_isBonus) * 40), 0);
	
	for (int i=0; i<[arrStarSprite count]; i++) {
		
		CCSprite *sprite = [arrStarSprite objectAtIndex:i];
		[sprite setPosition:cpvadd(pos, cpv((CCRANDOM_0_1() * 2) - 1, (CCRANDOM_0_1() * 2) - 1))];
		
		[sprite runAction:[CCScaleTo actionWithDuration:0.1f scale:(CCRANDOM_0_1() * 0.25) + 0.875]];
		pos = cpvadd(pos, cpv(80, 0));
	}
}

@end





/*
 CFDataRef xmlData;
 Boolean status;
 SInt32 errorCode;
 
 // Convert the property list into XML data.
 xmlData = CFPropertyListCreateXMLData( kCFAllocatorDefault, [[AchievementsPlistParser alloc] dicTopLvl] );
 
 // Write the XML data to the file.
 status = CFURLWriteDataAndPropertiesToResource (
 @"Achievements.plist",				  // URL to use
 xmlData,				  // data to write
 NULL,
 &errorCode);
 
 CFRelease(xmlData);
 */

