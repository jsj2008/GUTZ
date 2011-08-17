//
//  MainMenuScreenLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "ScreenManager.h"

#import "BaseScreenLayer.h"
#import "ConfigMenuLayer.h"
#import "LevelSelectScreenLayer.h"

#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"


@interface MainMenuScreenLayer : BaseScreenLayer {
	
	ChipmunkSpace *_space;
	JellyBlob *_accBlob1;
	JellyBlob *_accBlob2;
	JellyBlob *_accBlob3;
	JellyBlob *_accBlob4;
	
}

- (void)onNewGame:(id)sender;
- (void)onStore:(id)sender;
- (void)onAbout:(id)sender;
- (void)onConfig:(id)sender;

- (void)physicsStepper:(ccTime)dt;
- (void)mobWiggler:(id)sender;
@end
