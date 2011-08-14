//
//  GameOverLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelCompleteScreenLayer.h"
#import "AchievementsPlistParser.h"



@implementation LevelCompleteScreenLayer

-(id) init {
    NSLog(@"LevelCompleteScreenLayer.init()");
    
	//self = [super init];
	self = [super initWithBackround:@"background_default.jpg"];
	
	NSDate *unixTime = [[NSDate alloc] initWithTimeIntervalSince1970:0];
	NSLog(@":::::::::::::[%d]:::::::::::::", unixTime);
    
    //CCSprite *bg = [CCSprite spriteWithFile: @"background_static.jpg"];
	//bg.position = ccp(160, 240);
    //[self addChild: bg z:0];
    
    CCSprite *divLine1 = [CCSprite spriteWithFile: @"divider.png"];
    divLine1.position = ccp(160, 280);
    [self addChild: divLine1 z:0];
    
    CCSprite *divLine2 = [CCSprite spriteWithFile: @"divider.png"];
    divLine2.position = ccp(160, 180);
    [self addChild: divLine2 z:0];
    
	float delayTime = 0.3f;
	
	CCMenuItemImage *nextLevelButton = [CCMenuItemImage itemFromNormalImage:@"button_nextLevel_nonActive.png" selectedImage:@"button_nextLevel_Active.png" target:self selector:@selector(onNextLevel:)];
    [nextLevelButton setScale:0.0f];
    
    CCMenu *menu = [CCMenu menuWithItems:nextLevelButton, nil];
    CCAction *action = [CCSequence actions: [CCDelayTime actionWithDuration: delayTime], [CCScaleTo actionWithDuration:0.5f scale:1.0f], nil];
    
    delayTime += 0.1f;
    [nextLevelButton runAction: action];
	
	menu.position = ccp(160, 50);
	[self addChild:menu z:2];
	
		
	return (self);
}

-(void) onNextLevel:(id)sender { 
    NSLog(@"LevelCompleteScreenLayer.onNextLevel()");
	[ScreenManager goPlay];
}

-(void) onBackMenu:(id)sender {
    NSLog(@"LevelCompleteScreenLayer.onBackMenu()");
	[ScreenManager goMenu];
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

