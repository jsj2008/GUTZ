//
//  LevelSelectScreenLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "BaseScreenLayer.h"
#import "LvlBtnSprite.h"

#import "ScreenManager.h"


#define kLVL_NUM_SCALE_MULT 0.4f

@interface LevelSelectScreenLayer : BaseScreenLayer {
    
	CCSpriteBatchNode *digitBatchSprite;
	
	CGPoint digitSize;
	
    
}


-(LvlBtnSprite *) makeBtn:(int)ind locked:(BOOL)isLocked;
-(void) onBackMenu:(id)sender;
-(void) onLevelSelect:(id)sender;


+ (void) onPageChange:(int)ind;


@end
