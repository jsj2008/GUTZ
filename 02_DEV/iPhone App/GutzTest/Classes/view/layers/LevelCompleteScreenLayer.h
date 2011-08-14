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

@interface LevelCompleteScreenLayer : BaseScreenLayer {
    
}

-(void) onBackMenu:(id)sender;
-(void) onNextLevel:(id)sender;


@end
