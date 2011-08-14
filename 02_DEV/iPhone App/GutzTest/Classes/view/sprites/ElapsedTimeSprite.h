//
//  ElapsedTimeSprite.h
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#define kTIME_NUM_SCALE_MULT 0.8f

@interface ElapsedTimeSprite : CCSprite {
	CCSpriteBatchNode* digitBatchSprite;
	
	CCSprite* colonSprite;
	CCSprite* digit0001Sprite;
	CCSprite* digit0010Sprite;
	CCSprite* digit0100Sprite;
	CCSprite* digit1000Sprite;
	
	NSArray *arrSpriteDigits;
	NSMutableArray *arrPrevDigits;
	
	int totTime;
	CGPoint digitSize;
	
	
	NSNumber *lastClockTime;
	NSNumber *stopClockTime;
	
	
}

@property (nonatomic, retain) NSArray *arrSpriteDigits;
@property (nonatomic, retain) NSMutableArray *arrPrevDigits;

@property (nonatomic, retain) NSNumber *lastClockTime;
@property (nonatomic, retain) NSNumber *stopClockTime;
@property (nonatomic, retain) NSNumber *offsetTick;


-(CCSprite *) makeDigit:(int)zPos value:(int)value;
-(void) replaceDigit:(int)zPos value:(int)value;

-(void) clockStepper:(ccTime)delta;
-(void) onGamePause:(NSNotification *)notification;



-(void) derpSelctr:(id)sender;
@end
