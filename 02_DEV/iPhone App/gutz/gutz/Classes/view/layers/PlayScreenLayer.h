//
//  PlayScreenLayer.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "AlgebraUtils.h"
#import "GameConfig.h"

#import "ScreenManager.h"
#import "BaseScreenLayer.h"


#define PHYSICS_STEP_INC 2


@interface PlayScreenLayer : BaseScreenLayer {
	
	CGPoint *lastTouch;
	
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	
    //cpSpace *space;
	
	NSMutableArray *arrCreatureVO;
	
	CCSprite *segHolderSprite;
	CCSprite *hudStarsSprite;
	CCSprite *scoreDisplaySprite;
	CCSprite *timeDisplaySprite;
	
	CCMenuItemToggle *btnPlayPauseToggle;
    
	CCMenuItemImage *btnPauseToggle;
    
    int score_amt;
}

@property (nonatomic, readwrite) int score_amt;
@property (nonatomic, retain) NSMutableArray *arrCreatureVO;

-(void) onBackMenu:(id)sender;
-(void) onLevelComplete:(id)sender;
-(void) onGameOver:(id)sender;
-(void) onPlayPauseToggle:(id)sender;
-(void) physicsStepper:(ccTime)dt;
-(void) derpSelector:(id)sender;
-(void) box2dSetup;
-(void) scaffoldHUD;
-(void) debuggingSetup;

-(void) wiggler:(id)sender;

//-(cpBody *) findInnerNode:(int)ind;
@end
