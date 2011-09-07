//
//  MainMenuScreenLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 06/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "ScreenManager.h"

#import "BasePhysicsLayer.h"
#import "ConfigMenuLayer.h"
#import "LevelSelectScreenLayer.h"

#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"


@interface MainMenuScreenLayer : BasePhysicsLayer {
	
}

-(void)onNewGame:(id)sender;
-(void)onStore:(id)sender;
-(void)onAbout:(id)sender;
-(void)onConfig:(id)sender;


@end
