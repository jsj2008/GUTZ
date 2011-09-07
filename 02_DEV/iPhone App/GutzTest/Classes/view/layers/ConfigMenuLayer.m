//
//  ConfigMenuLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameConsts.h"
#import "GameConfig.h"

#import "ConfigMenuLayer.h"
#import "GameSettingsModel.h"

#import "SimpleAudioEngine.h"


@implementation ConfigMenuLayer

-(id) init {
	NSLog(@"%@.init()", [self class]);
	
	if ((self = [super initWithBackround:MENU_BG_ASSET])) {
		
		CCMenu *optionsMenu = [self scaffoldMenu];
		optionsMenu.position = ccp(160, 220);
		[optionsMenu alignItemsVerticallyWithPadding: 48.0f];
		[self addChild:optionsMenu z: 2];
		
		[self introMenu:optionsMenu];
		[self procureSettings];
	}
	
	return (self);
}

- (CCMenu *)scaffoldMenu {
	
	CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"button_options_nonActive.png" selectedImage:@"button_options_Active.png" target:self selector:@selector(onBackMenu:)];
	
	CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
	backMenu.position = ccp(35, 440);
	[self addChild:backMenu z:2];
	
	CCMenuItemImage *soundsOnButton = [CCMenuItemImage itemFromNormalImage:@"button_soundOn_nonActive.png" selectedImage:@"button_soundOn_Active.png" target:nil selector:nil];
	CCMenuItemImage *soundsOffButton = [CCMenuItemImage itemFromNormalImage:@"button_soundOff_nonActive.png" selectedImage:@"button_soundOff_Active.png" target:nil selector:nil];
	soundsToggleButton = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundsToggle:) items:soundsOffButton, soundsOnButton, nil];
	
	CCMenuItemImage *pushesOnButton = [CCMenuItemImage itemFromNormalImage:@"button_pushNotificationON_nonActive.png" selectedImage:@"button_pushNotificationON_Active.png" target:nil selector:nil];
	CCMenuItemImage *pushesOffButton = [CCMenuItemImage itemFromNormalImage:@"button_pushNotificationOFF_nonActive.png" selectedImage:@"button_pushNotificationOFF_Active.png" target:nil selector:nil];
	pushesToggleButton = [CCMenuItemToggle itemWithTarget:self selector:@selector(onPushesToggle:) items:pushesOffButton, pushesOnButton, nil];
	
	CCMenuItemImage *infoButton = [CCMenuItemImage itemFromNormalImage:@"button_moreInfo_nonActive.png" selectedImage:@"button_moreInfo_Active.png" target:self selector:@selector(onInfo:)];
	
	return ([CCMenu menuWithItems:soundsToggleButton, pushesToggleButton, infoButton, nil]);
	
}


-(void)introMenu:(CCMenu *)menu {
	
	float delayTime = 0.33f;
	
	for (CCMenuItem *itm in [menu children]) {
		itm.scale = 0.0f;
		
		CCAction *action = [CCSequence actions:[CCDelayTime actionWithDuration: delayTime], [CCScaleTo actionWithDuration:0.5f scale:1.0], nil];
		
		delayTime += 0.2f;
		[itm runAction: action];
	}
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
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger isSFX = [prefs integerForKey:@"enable_sfx"];
	soundsToggleButton.selectedIndex = isSFX;
	NSLog(@"[standardUserDefaults enable_sfx]:(%d)", isSFX);
	
	//[plistSettings writeNumberByKey:@"Played Timestamp" val:[[CCDirector sharedDirector] startTime]];
	//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:YES] forKey:@"Pushes Enabled"];
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
	BOOL isEnabled;
	
	if (toggleBtn.selectedIndex == 0)
		isEnabled = YES;
	
	else
		isEnabled = NO;
	
	[plistSettings writeBoolByKey:@"Pushes Enabled" val:isEnabled];//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:YES] forKey:@"Pushes Enabled"];
	NSLog(@"-/> %@.%@ [%d] </-", [self class], @"onPushesToggle", isEnabled);
}

-(void) onSoundsToggle:(id)sender {
	
	CCMenuItemToggle *toggleBtn = (CCMenuItemToggle *)sender;
	BOOL isEnabled;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:toggleBtn.selectedIndex forKey:@"enable_sfx"];
	[prefs synchronize];
	
	if (toggleBtn.selectedIndex == 0)
		isEnabled = NO;
	
	else
		isEnabled = YES;
	
	[[SimpleAudioEngine sharedEngine] setMute:!isEnabled];
	[plistSettings writeBoolByKey:@"Sounds Enabled" val:isEnabled];//[[plistSettings dicTopLvl] setValue:[NSNumber numberWithBool:YES] forKey:@"Pushes Enabled"];
	
	
	NSLog(@"-/> %@.%@ [%d] </-", [self class], @"onSoundsToggle", isEnabled);
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

