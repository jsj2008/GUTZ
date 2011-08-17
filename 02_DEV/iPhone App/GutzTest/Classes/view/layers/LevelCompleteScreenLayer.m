//
//  GameOverLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelCompleteScreenLayer.h"
#import "AchievementsPlistParser.h"
#import "ChipmunkDebugNode.h"

#import "RandUtils.h"


static NSString *borderType = @"borderType";


@implementation LevelCompleteScreenLayer

-(id)initWithLevel:(int)lvl {
	
	indLvl = lvl;
	
	return ([self init]);
}

-(id) init {
    NSLog(@"LevelCompleteScreenLayer.init()");
    CGSize wins = [[CCDirector sharedDirector] winSize];
	
	//self = [super init];
	self = [super initWithBackround:@"background_main.jpg"];
	
	NSDate *unixTime = [[NSDate alloc] initWithTimeIntervalSince1970:0];
	NSLog(@":::::::::::::[%d]:::::::::::::", unixTime);
    
    //CCSprite *bg = [CCSprite spriteWithFile: @"background_static.jpg"];
	//bg.position = ccp(160, 240);
    //[self addChild: bg z:0];
	
	
	cpInitChipmunk();
	
	_space = [[ChipmunkSpace alloc] init];
	_space.gravity = cpv(0, 0);
	
	[self addChild:[ChipmunkDebugNode debugNodeForSpace:_space]];
	
	CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
	[_space addBounds:rect thickness:532 elasticity:1 friction:1 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	
	
	_accBlob1 = [[JellyBlob alloc] initWithPos:cpv(64, 100) radius:32 count:16];
	[_space add:_accBlob1];
	
	_accBlob2 = [[JellyBlob alloc] initWithPos:cpv(160, 120) radius:16 count:8];
	[_space add:_accBlob2];
	
	_accBlob3 = [[JellyBlob alloc] initWithPos:cpv(240, 240) radius:24 count:12];
	[_space add:_accBlob3];
	
	[self schedule:@selector(physicsStepper:)];
	[self schedule:@selector(mobWiggler:) interval:0.25f + (CCRANDOM_0_1() * 0.125f)];
    
	float delayTime = 0.3f;
	
	CCMenuItemImage *btnReplayLevel = [CCMenuItemImage itemFromNormalImage:@"btn_replay.png" selectedImage:@"btn_replayActive.png" target:self selector:@selector(onReplayLevel:)];
	
	CCMenuItemImage *btnNextLevel = [CCMenuItemImage itemFromNormalImage:@"btn_next.png" selectedImage:@"btn_nextActive.png" target:self selector:@selector(onNextLevel:)];
	[btnNextLevel setScale:0.0f];
	
	CCMenu *menu = [CCMenu menuWithItems:btnReplayLevel, btnNextLevel, nil];
	CCAction *action = [CCSequence actions:[CCDelayTime actionWithDuration:delayTime], [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil];
   
	delayTime += 0.1f;
	[btnNextLevel runAction:action];
	
	menu.position = ccp(160, 250);
	[menu alignItemsVerticallyWithPadding:100.0f];
	[self addChild:menu z:2];
	
		
	return (self);
}

-(void) onNextLevel:(id)sender { 
    NSLog(@"LevelCompleteScreenLayer.onNextLevel()");
	[ScreenManager goPlay:++indLvl];
}

-(void) onReplayLevel:(id)sender { 
	NSLog(@"LevelCompleteScreenLayer.onReplayLevel()");
	[ScreenManager goPlay:indLvl];
}

-(void) onBackMenu:(id)sender {
    NSLog(@"LevelCompleteScreenLayer.onBackMenu()");
	[ScreenManager goMenu];
}


-(void) physicsStepper: (ccTime) dt {
	//NSLog(@"PlayScreenLayer.physicsStepper(%0.000000f)", [[CCDirector sharedDirector] getFPS]);
	
	[_space step:1.0 / 60.0];
	[_accBlob1 draw];
}


-(void) mobWiggler:(id)sender {
	
	cpFloat maxForce = 4.0f;
	
	cpFloat rndForce = CCRANDOM_0_1() * maxForce;
	
	
	switch (((int)CCRANDOM_0_1() * 3)) {
		case 0:
			[_accBlob1 wiggleWithForce:[[RandUtils singleton]randIndex:32] force:rndForce];
			break;
			
		case 1:
			[_accBlob2 wiggleWithForce:[[RandUtils singleton]randIndex:16] force:rndForce];
			break;
			
		case 2:
			[_accBlob3 wiggleWithForce:[[RandUtils singleton]randIndex:24] force:rndForce];
			break;
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
 @"Achievements.plist",                  // URL to use
 xmlData,                  // data to write
 NULL,
 &errorCode);
 
 CFRelease(xmlData);
 */

