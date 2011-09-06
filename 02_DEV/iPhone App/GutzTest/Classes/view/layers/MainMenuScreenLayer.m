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
#import "ChipmunkDebugNode.h"

#import "DigitUtils.h"
#import "RandUtils.h"

#import "SimpleAudioEngine.h"


static NSString *borderType = @"borderType";

@implementation MainMenuScreenLayer

-(id) init {
    NSLog(@"MainMenuScreenLayer.init()");
   
	
	if ((self = [super initWithBackround:MENU_BG_ASSET])) {
		
		CGSize wins = [[CCDirector sharedDirector] winSize];
		float delayTime = 0.3f;
		
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.95];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"buttonSound.wav"];
		
		cpInitChipmunk();
		
		_space = [[ChipmunkSpace alloc] init];
		_space.gravity = cpv(0, 0);
		
		//[self addChild:[ChipmunkDebugNode debugNodeForSpace:_space]];
		
		CGRect rect = CGRectMake(0, 0, wins.width, wins.height);
		[_space addBounds:rect thickness:532 elasticity:1 friction:1 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
		
		
		/*
		 _accBlob1 = [[JellyBlob alloc] initWithPos:cpv(164, 100) radius:32 count:16];
		_accBlob1.rFillColor = 1.0f;
		_accBlob1.gFillColor = 0.37f;
		_accBlob1.bFillColor = 0.37f;
		[_space add:_accBlob1];
		
		_accBlob2 = [[JellyBlob alloc] initWithPos:cpv(160, 120) radius:16 count:8];
		[_space add:_accBlob2];
		
		_accBlob3 = [[JellyBlob alloc] initWithPos:cpv(140, 210) radius:24 count:12];
		[_space add:_accBlob3];
		
		_accBlob4 = [[JellyBlob alloc] initWithPos:cpv(40, 232) radius:8 count:8];
		[_space add:_accBlob4];
		
		[self schedule:@selector(physicsStepper:)];
		[self schedule:@selector(mobWiggler:) interval:0.25f + (CCRANDOM_0_1() * 0.125f)];
		*/
		
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


-(void) physicsStepper: (ccTime) dt {
	//NSLog(@"PlayScreenLayer.physicsStepper(%0.000000f)", [[CCDirector sharedDirector] getFPS]);
	
	[_space step:1.0 / 60.0];
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

@end



/*
 CCLabelTTF *titleLeft = [CCLabelTTF labelWithString:@"Menu " fontName:@"Marker Felt" fontSize:48];
 CCAction *titleLeftAction = [CCSequence actions: [CCDelayTime actionWithDuration: delayTime], [CCEaseBackOut actionWithAction: [CCMoveTo actionWithDuration: 1.0 position:ccp(80,345)]], nil];
 [self addChild: titleLeft];
 [titleLeft runAction: titleLeftAction];
*/