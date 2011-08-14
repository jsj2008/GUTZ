//
//  GameOverScreenLayer.m
//  GutzTest
//
//  Created by Gullinbursti on 07/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameOverScreenLayer.h"
#import "CCDirector.h"

@implementation GameOverScreenLayer


-(void) onMainMenu:(id)sender {
	[ScreenManager goMenu];
}


-(void) onExitGame:(id)sender {
	[self goFinale];
	//[[CCDirector sharedDirector] end];
}

-(void) goFinale {
}
@end


//
//-(void) introFinaleAct {
//	NSLog(@"ScreenManager.goFinaleAct()");
//	
//	
//	
//	[CCDirector sharedDirector] performSelector:<#(SEL)#> withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>
//	
//	
//};
//
//