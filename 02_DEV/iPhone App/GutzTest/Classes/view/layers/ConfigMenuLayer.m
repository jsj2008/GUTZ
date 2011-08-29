//
//  ConfigMenuLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameConsts.h"

#import "ConfigMenuLayer.h"


@implementation ConfigMenuLayer

-(id) init {
	NSLog(@"%s.init()", [self class]);
	
	//self = [super init];
	self = [super initWithBackround:@"background_default.png"];
	
	if (!self)
		return (nil);
    
    //CCSprite *bg = [CCSprite spriteWithFile: @"background_default.jpg"];
	//bg.position = ccp(160, 240);
    //[self addChild: bg z:0];
    
    float delayTime = 0.3f;
    
    CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"button_options_nonActive.png" selectedImage:@"button_options_Active.png" target:self selector:@selector(onBackMenu:)];
    
    CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
    backMenu.position = ccp(35, 440);
    [self addChild:backMenu z:2];

    CCMenuItemImage *soundsOnButton = [CCMenuItemImage itemFromNormalImage:@"button_soundOn_nonActive.png" selectedImage:@"button_soundOn_Active.png" target:nil selector:nil];
    CCMenuItemImage *soundsOffButton = [CCMenuItemImage itemFromNormalImage:@"button_soundOff_nonActive.png" selectedImage:@"button_soundOff_Active.png" target:nil selector:nil];
    soundsToggleButton = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundsToggle:) items:soundsOnButton, soundsOffButton, nil];
    
    CCMenuItemImage *pushesOnButton = [CCMenuItemImage itemFromNormalImage:@"button_pushNotificationON_nonActive.png" selectedImage:@"button_pushNotificationON_Active.png" target:nil selector:nil];
    CCMenuItemImage *pushesOffButton = [CCMenuItemImage itemFromNormalImage:@"button_pushNotificationOFF_nonActive.png" selectedImage:@"button_pushNotificationOFF_Active.png" target:nil selector:nil];
    pushesToggleButton = [CCMenuItemToggle itemWithTarget:self selector:@selector(onPushesToggle:) items:pushesOnButton, pushesOffButton, nil];
    
    CCMenuItemImage *infoButton = [CCMenuItemImage itemFromNormalImage:@"button_moreInfo_nonActive.png" selectedImage:@"button_moreInfo_Active.png" target:self selector:@selector(onInfo:)];
	
    CCMenu *optionsMenu = [CCMenu menuWithItems:soundsToggleButton, pushesToggleButton, infoButton, nil];
	
	for (CCMenuItem *itm in [optionsMenu children]) {
		itm.scale = 0.0f;
		
		CCAction *action = [CCSequence actions: 
			[CCDelayTime actionWithDuration: delayTime], 
			[CCScaleTo actionWithDuration:0.5F scale:1.0], nil];
		
		delayTime += 0.2f;
		[itm runAction: action];
	}
	
    optionsMenu.position = ccp(160, 240);
    [optionsMenu alignItemsVerticallyWithPadding: 95.0f];
    [self addChild:optionsMenu z: 2];
	
	
	[self procureSettings];
	
	
	return (self);
}


-(void) procureSettings {
	
	//SettingsModel *model = [[SettingsModel alloc] init];
	
	plistSettings = [[SettingsPlistParser alloc] init];
	NSLog(@"SettingsPlistParser.urlMoreInfo:[%@]", [plistSettings urlMoreInfo]);
	NSLog(@"SettingsPlistParser.urlArtistPage:[%@]", [plistSettings urlArtistPage]);
	NSLog(@"SettingsPlistParser.urlStudioPage:[%@]", [plistSettings urlStudioPage]);
	NSLog(@"SettingsPlistParser.isPushes:[%@]", (BOOL *)[[plistSettings dicTopLvl] objectForKey:@"Pushes Enabled"]);
	NSLog(@"SettingsPlistParser.isSounds:[%@]", (BOOL *)[[plistSettings dicTopLvl] objectForKey:@"Sounds Enabled"]);
	NSLog(@"SettingsPlistParser.lastPlayed:[%@]", [[plistSettings dicTopLvl] objectForKey:@"Played Timestamp"]);
	
	
	if ([[[plistSettings dicTopLvl] objectForKey:@"Pushes Enabled"] isEqualToNumber:[NSNumber numberWithInt:1]])
		pushesToggleButton.selectedIndex = 0;
	
	else
		pushesToggleButton.selectedIndex = 1;
	
	//NSLog(@"[pushesToggleButton selectedItem]:(%@, %d)", [pushesToggleButton selectedItem], [pushesToggleButton selectedIndex]);
	
	
	if ([[[plistSettings dicTopLvl] objectForKey:@"Sounds Enabled"] isEqualToNumber:[NSNumber numberWithInt:1]])
		soundsToggleButton.selectedIndex = 0;
	
	else
		soundsToggleButton.selectedIndex = 1;
	
	//NSLog(@"[soundsToggleButton selectedItem]:(%@, %d)", [soundsToggleButton selectedItem], [soundsToggleButton selectedIndex]);
	
	
	//[plistSettings writeNumberByKey:@"Played Timestamp" val:[[CCDirector sharedDirector] startTime]];//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:YES] forKey:@"Pushes Enabled"];
}


-(void) onBackMenu:(id)sender {
	[ScreenManager goMenu];
}

-(void) onInfo:(id)sender {
    NSLog(@"-/> %@.%@() </-", [self class], @"onInfo");
	
	[[CCDirector sharedDirector] pause];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [plistSettings urlMoreInfo]]];
}


-(void) onPushesToggle:(id)sender {
    CCMenuItemToggle *toggleBtn = (CCMenuItemToggle *)sender;
	
	if (toggleBtn.selectedIndex == 0)
		[plistSettings writeBoolByKey:@"Pushes Enabled" val:YES];//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:YES] forKey:@"Pushes Enabled"];
	
	else
		[plistSettings writeBoolByKey:@"Pushes Enabled" val:NO];//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:NO] forKey:@"Pushes Enabled"];
	
	
	//NSLog(@"-/> %@.%@(%@) [%d] </-", [self class], @"onPushesToggle", [[plistSettings dicTopLvl] objectForKey:@"Pushes Enabled"], toggleBtn.selectedIndex);
}

-(void) onSoundsToggle:(id)sender {
	
	CCMenuItemToggle *toggleBtn = (CCMenuItemToggle *)sender;
	
	if (toggleBtn.selectedIndex == 0)
		[plistSettings writeBoolByKey:@"Sounds Enabled" val:YES];//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:YES] forKey:@"Pushes Enabled"];
		 
	else
		[plistSettings writeBoolByKey:@"Sounds Enabled" val:NO];//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:YES] forKey:@"Pushes Enabled"];
	
	//NSLog(@"-/> %@.%@(%@) [%d] </-", [self class], @"onSoundsToggle", [[plistSettings dicTopLvl] objectForKey:@"Sounds Enabled"], toggleBtn.selectedIndex);
}


@end



/*
 AchievementsPlistParser* plistAchievments = [[AchievementsPlistParser alloc] init];
 NSLog(@"plistAchievments.dicTopLvl:[%d]", [plistAchievments arrItmEntries]);
 
 for (int i=0; i<[[plistAchievments arrItmEntries] count]; i++) {
 NSLog(@"  -/> plistAchievments.arrItems[%d]=(%@) </-", i, [[plistAchievments arrItmEntries] objectAtIndex:i]);
 }
 */

