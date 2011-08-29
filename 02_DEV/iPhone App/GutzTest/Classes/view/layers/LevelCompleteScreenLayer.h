//
//  GameOverLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScreenManager.h"

#import "BaseScreenLayer.h"
#import "PlayScreenLayer.h"

#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"

@interface LevelCompleteScreenLayer : BaseScreenLayer {
    
	int indLvl;
	
	
	ChipmunkSpace *_space;
	JellyBlob *_accBlob1;
	JellyBlob *_accBlob2;
	JellyBlob *_accBlob3;
	
	
	NSMutableArray *arrLetterSprite;
	NSMutableArray *arrStarSprite;
}


-(id)initWithLevel:(int)lvl;
-(void) onBackMenu:(id)sender;
-(void) onReplayLevel:(id)sender;
-(void) onNextLevel:(id)sender;


-(void) physicsStepper:(ccTime)dt;
-(void)letterWiggleProvoker:(id)sender;
-(void)starWiggleProvoker:(id)sender;
-(void) mobWiggler:(id)sender;
-(void)letterWiggler:(id)sender;
-(void)starWiggler:(id)sender;


@end
