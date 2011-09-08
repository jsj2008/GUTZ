//
//  RootViewController.m
//  GutzTest
//
//  Created by Gullinbursti on 06/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//





#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"

#import "CCDirector.h"

@implementation RootViewController


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
	
-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}


-(void)dealloc {
	[super dealloc];
}


@end

