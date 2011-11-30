//
//  ScoreSprite.m
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreSprite.h"

#import "DigitUtils.h"
#import "AlgebraUtils.h"



enum {
	kTagBatchNode = 3513,
};

@implementation ScoreSprite

@synthesize uiScore_ = uiScore;

-(id) init {
	
	if ((self = [super init])) {
		
		uiScore = 0;
		digitSize = CGPointMake(52, 60);
		digitBatchSprite = [CCSpriteBatchNode batchNodeWithFile:@"scoreDigits_spritemap.png" capacity:4];
		[self addChild:digitBatchSprite z:0 tag:kTagBatchNode];
		
		digit0001Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(0, 0, digitSize.x, digitSize.y)];
		digit0010Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(0, 0, digitSize.x, digitSize.y)];
		digit0100Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(0, 0, digitSize.x, digitSize.y)];
		digit1000Sprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(0, 0, digitSize.x, digitSize.y)];
		
		[self makeDigit:0 value:0];
		[self makeDigit:1 value:0];
		[self makeDigit:2 value:0];
		[self makeDigit:3 value:0];
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScoreChange:) name:@"ScoreChanged" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScoreChange:) name:@"UPD_LVL" object:nil];
	}
	
	return (self);
	
	
	
	//CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"grossini_dance_atlas.png" capacity:100];
}




- (void) onScoreChange:(NSNotification *)notification {
    NSNumber *amt = (NSNumber *)[notification object];
	
	uiScore += [amt integerValue];
	int thous = [[DigitUtils singleton]thousands:uiScore];
	int hunds = [[DigitUtils singleton]hundreds:uiScore];
	int tens = [[DigitUtils singleton]tens:uiScore];
	int ones = [[DigitUtils singleton]ones:uiScore];
	
	
	//NSLog(@"-//>> onScoreChange <<\\- adj:[%d] ][ inc:[%d] ][ 1000*(%d) 100*(%d) 10*(%d) 1*(%d)", uiScore, [amt integerValue], thous, hunds, tens, ones);
	
	[self replaceDigit:0 value:ones];
	[self replaceDigit:1 value:tens];
	[self replaceDigit:2 value:hunds];
	[self replaceDigit:3 value:thous];
	
	
    // Retrieve information about the document and update the panel
} 

-(CCSprite *) makeDigit:(int)zPos value:(int)value {
	int sprite_tag = (-1000 - (int)[[AlgebraUtils singleton] expo:zPos base:10.0f]) - value;
	
	CCSprite *digitSprite = [CCSprite spriteWithBatchNode:digitBatchSprite rect:CGRectMake(value * digitSize.x, 0, digitSize.x, digitSize.y)];
	[digitSprite setPosition:ccp((78 * kSCORE_SCALE_MULT) - (zPos * (40 * kSCORE_SCALE_MULT)), 0)];
	[digitSprite setScaleX:0.0f];
	[digitSprite setScaleY:[[AlgebraUtils singleton] third:kSCORE_SCALE_MULT]];
	
	
	[digitBatchSprite addChild:digitSprite z:zPos tag:sprite_tag];
	[digitSprite runAction:[CCSequence actions: [CCEaseInOut actionWithDuration:0.1f], [CCScaleTo actionWithDuration:0.1f scale:kSCORE_SCALE_MULT], nil]];
	
	return (digitSprite);
}


-(void) replaceDigit:(int)zPos value:(int)value { 
	
	int sprite_tag = -1000 - (int)[[AlgebraUtils singleton] expo:zPos base:10.0f] - value;
	
	CCSprite *digitSprite = (CCSprite*)[digitBatchSprite getChildByTag:sprite_tag];
    //NSLog(@"%@.replaceDigit(%d) -[%d]{%d}- /%d/", [self class], zPos, value, sprite_tag, [digitSprite tag]);
	
	if ([digitSprite tag] != sprite_tag) {
		[digitSprite runAction:[CCSequence actions: [CCEaseInOut actionWithDuration:0.1f], [CCScaleTo actionWithDuration:0.1f scale:[[AlgebraUtils singleton] dbl:kSCORE_SCALE_MULT]], [CCFadeTo actionWithDuration:0.15f opacity:0], nil]];
		
		[digitBatchSprite removeChildAtIndex:zPos cleanup:YES];
		[self makeDigit:zPos value:value];
	}
}
@end
