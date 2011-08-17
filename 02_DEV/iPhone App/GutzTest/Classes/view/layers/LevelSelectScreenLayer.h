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

#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"


#define kLVL_NUM_SCALE_MULT 0.4f

@interface LevelSelectScreenLayer : BaseScreenLayer {
    
	CCSpriteBatchNode *digitBatchSprite;
	
	CGPoint digitSize;
	
	ChipmunkSpace *_space;
	JellyBlob *_accBlob1;
	JellyBlob *_accBlob2;
	JellyBlob *_accBlob3;
	JellyBlob *_accBlob4;
	
    
}


-(LvlBtnSprite *) makeBtn:(int)ind locked:(BOOL)isLocked;
-(void) onBackMenu:(id)sender;
-(void) onLevelSelect:(id)sender;


+ (void) onPageChange:(int)ind;

-(void) physicsStepper:(ccTime)dt;
-(void) mobWiggler:(id)sender;

@end
