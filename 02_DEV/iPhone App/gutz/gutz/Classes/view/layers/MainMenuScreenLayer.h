//
//  MainMenuScreenLayer.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "ScreenManager.h"

#import "BaseScreenLayer.h"
#import "ConfigMenuLayer.h"
#import "LevelSelectScreenLayer.h"


@interface MainMenuScreenLayer : BaseScreenLayer {
}

- (void) onNewGame:(id)sender;
- (void) onConfig:(id)sender;
@end
