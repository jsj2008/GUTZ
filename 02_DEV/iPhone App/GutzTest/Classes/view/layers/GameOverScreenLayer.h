//
//  GameOverScreenLayer.h
//  GutzTest
//
//  Created by Gullinbursti on 07/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseScreenLayer.h"
#import "ScreenManager.h"


@interface GameOverScreenLayer : BaseScreenLayer {
    
}

-(void) onMainMenu:(id)sender;
-(void) onExitGame:(id)sender;
-(void) goFinale;

@end
