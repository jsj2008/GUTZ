//
//  ScoreSprite.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "cocos2d.h"

#define kSCORE_SCALE_MULT 0.8f

@interface ScoreSprite : CCSprite {
	
	int uiScore;
	
	CCSpriteBatchNode* digitBatchSprite;
	
	CCSprite* digit0001Sprite;
	CCSprite* digit0010Sprite;
	CCSprite* digit0100Sprite;
	CCSprite* digit1000Sprite;
	
	CGPoint digitSize;
	
}

-(CCSprite *) makeDigit:(int)zPos value:(int)value;
-(void) replaceDigit:(int)zPos value:(int)value;

@property (nonatomic, readwrite, assign) int uiScore_;

@end

