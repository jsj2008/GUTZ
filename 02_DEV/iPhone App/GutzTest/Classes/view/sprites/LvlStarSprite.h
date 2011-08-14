//
//  LvlStarSprite.h
//  GutzTest
//
//  Created by Gullinbursti on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface LvlStarSprite : CCSprite {
	
	NSMutableArray *arrStarsVO;
	NSMutableArray *arrStarsSprite;
	CCSprite *star01Sprite;
	CCSprite *star02Sprite;
	CCSpriteBatchNode *starsBatchSprite;
	
	CCSprite* digit0001Sprite;
	CCSprite* digit0010Sprite;
	int totFilled;
	
}


-(id) init;
-(void) frameAnimator:(ccTime)delta;

-(void) tare;
-(void) fillByIndex:(int)ind;
-(void) fillAll;
-(void) clearByIndex:(int *)ind;
-(void) clearInBatch:(NSArray *)arrClear;

@property (nonatomic, readwrite) int totFilled;


@end
