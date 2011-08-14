//
//  ElapsedTimeSprite.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ElapsedTimeSprite.h"



#import "DigitUtils.h"
#import "AlgebraUtils.h"
#import "TimeUtils.h"
#import "DataTypeUtils.h"

@implementation ElapsedTimeSprite


@synthesize arrSpriteDigits;
@synthesize arrPrevDigits;

@synthesize lastClockTime;
@synthesize stopClockTime;
@synthesize offsetTick;


-(id) init {
	
	if ((self = [super init])) {
		
		totTime = 0;
		digitSize = CGPointMake(52, 60);
		digitBatchSprite = [CCSpriteBatchNode batchNodeWithFile:@"timeDigits_spritemap.png" capacity:5];
		
		colonSprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(0, 0, digitSize.x, digitSize.y)];
		[colonSprite setPosition:ccp(0, 0)];
		[colonSprite setScale:kTIME_NUM_SCALE_MULT];
		
		digit0001Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(digitSize.x, 0, digitSize.x, digitSize.y)];
		digit0010Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(digitSize.x, 0, digitSize.x, digitSize.y)];
		digit0100Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(digitSize.x, 0, digitSize.x, digitSize.y)];
		digit1000Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(digitSize.x, 0, digitSize.x, digitSize.y)];
		
		arrPrevDigits = [[NSArray alloc] initWithObjects:0, 0, 0, 0, nil];
		
		for (int i=0; i<4; i++)
			[self makeDigit:i value:0];
		
		
		[digitBatchSprite addChild:colonSprite z:666];
		[self addChild:digitBatchSprite z:0];
		
		lastClockTime = [[NSNumber alloc] initWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
		stopClockTime = [[NSNumber alloc] initWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
		
		[self schedule:@selector(clockStepper:) interval:1.0f];
		//[self performSelector:@selector(derpSelctr:) withObject:nil afterDelay:0.6f];
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGamePause:) name:@"GameplayPauseToggle" object:nil];
	}
	
	return (self);
}


-(void) onGamePause:(NSNotification *)notification {
	NSLog(@"onGamePause(%@)%@][%d", [notification object], [[DataTypeUtils singleton]numberFromNote:notification], [[DataTypeUtils singleton]boolFromNote:notification]);
	
	
	if ([[DataTypeUtils singleton]boolFromNote:notification]) {
		stopClockTime = [[NSNumber alloc] initWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000.0f];
		//NSLog(@" .//>PAUSE @:[%@]", stopClockTime);
		
		[[CCScheduler sharedScheduler] pauseTarget:self];
		
	} else {
		//NSLog(@" .//>START @:[%@]", [NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000.0f]);
		[[CCScheduler sharedScheduler] resumeTarget:self];
	}
	
}

-(void) clockStepper:(ccTime)dt {
	//NSLog(@"clockStepper(%d) @ [%@]", totTime, lastClockTime);
	
	lastClockTime = [[NSNumber alloc] initWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000];
	totTime++;
	
	int totMins = [[TimeUtils singleton]minutesFromSeconds:totTime];
	int totSecs = [[TimeUtils singleton]secondsRemain:totTime];
	
	NSArray *arrDigitVals = [[[NSArray alloc] initWithObjects: 
							  [NSNumber numberWithInt:[[DigitUtils singleton]ones:totSecs]], 
							  [NSNumber numberWithInt:[[DigitUtils singleton]tens:totSecs]], 
							  [NSNumber numberWithInt:[[DigitUtils singleton]ones:totMins]], 
							  [NSNumber numberWithInt:[[DigitUtils singleton]tens:totMins]], 
							  nil] autorelease];
	
	
	for (int i=0; i<4; i++)
		[self replaceDigit:i value:[[arrDigitVals objectAtIndex:i] intValue]];
}


-(void) derpSelctr:(id)sender {
	NSLog(@"derpSelctr -- [%@]", sender);
	
	//int val = [sender message];
	[self replaceDigit:0 value:1];
}


-(CCSprite *) makeDigit:(int)zPos value:(int)value {
	//NSLog(@"%@.makeDigit(%d, %d)", [self class], zPos, value);
	
	CCSprite *digitSprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(52 + (value * digitSize.x), 0, digitSize.x, digitSize.y)];
	[digitSprite setScale:0.0f];
	
	if (zPos <= 1)
		[digitSprite setPosition:ccp(((54 * kTIME_NUM_SCALE_MULT) - (zPos * (36 * kTIME_NUM_SCALE_MULT))) + (10 * kTIME_NUM_SCALE_MULT), 0)];
	
	else 
		[digitSprite setPosition:ccp(((54 * kTIME_NUM_SCALE_MULT) - (zPos * (36 * kTIME_NUM_SCALE_MULT))) - (10 * kTIME_NUM_SCALE_MULT), 0)];
	
	
	[digitBatchSprite addChild:digitSprite z:zPos tag:zPos];
	//[arrPrevDigits replaceObjectAtIndex:zPos withObject:value];
	
	[digitSprite runAction:[CCSequence actions: [CCEaseInOut actionWithDuration:0.1f], [CCScaleTo actionWithDuration:0.1f scale:kTIME_NUM_SCALE_MULT], nil]];
	
	return (digitSprite);
}


-(void) replaceDigit:(int)zPos value:(int)value {
	//NSLog(@"%@.replaceDigit(%d, %d)", [self class], zPos, value);
	
	CCSprite *digitSprite = (CCSprite *)[digitBatchSprite getChildByTag:zPos];
	
    if (digitSprite) {
		[digitBatchSprite removeChild:digitSprite cleanup:YES];
		[self makeDigit:zPos value:value];
	}
	
	//[digitBatchSprite removeChildAtIndex:zPos cleanup:YES];
	//[digitBatchSprite removeChildByTag:zPos cleanup:YES];
	//[digitSprite removeFromParentAndCleanup:YES];
}


@end

