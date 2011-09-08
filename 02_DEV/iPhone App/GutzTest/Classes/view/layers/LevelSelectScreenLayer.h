//
//  LevelSelectScreenLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "BasePhysicsLayer.h"
#import "LvlBtnSprite.h"

#import "ScreenManager.h"



#define kLVL_NUM_SCALE_MULT 0.4f

@interface LevelSelectScreenLayer : BasePhysicsLayer {
    
	CCSpriteBatchNode *digitBatchSprite;
	
	CGPoint digitSize;
	int _prevLvl;
}

-(id)initFromLevel:(int)lvl;

-(LvlBtnSprite *)makeBtn:(int)ind locked:(BOOL)isLocked;

-(void)scaffoldMenu;
-(void)onBackMenu:(id)sender;
-(void)onLevelSelect:(id)sender;

@end
