//
//  GameOverLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScreenManager.h"

#import "BasePhysicsLayer.h"
#import "PlayScreenLayer.h"

#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"

@interface LevelCompleteScreenLayer : BasePhysicsLayer {
    
	int indLvl;
	BOOL _isBonus;
	
	
	NSMutableArray *arrLetterSprite;
	NSMutableArray *arrStarSprite;
}


-(id)initWithLevel:(int)lvl;
-(id)initWithLevel:(int)lvl withBonus:(BOOL)isBonus;

-(void) onBackMenu:(id)sender;
-(void) onReplayLevel:(id)sender;
-(void) onNextLevel:(id)sender;


-(void)letterWiggleProvoker:(id)sender;
-(void)starWiggleProvoker:(id)sender;
-(void)letterWiggler:(id)sender;
-(void)starWiggler:(id)sender;


@end
