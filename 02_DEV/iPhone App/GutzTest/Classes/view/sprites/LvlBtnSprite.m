//
//  LvlBtnSprite.m
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "LvlBtnSprite.h"
#import "ScreenManager.h"

@implementation LvlBtnSprite

@synthesize iLvlIndex;

-(id) init {
	if ((self = [super init])) {
		isLocked = YES;
	}
	
	return (self);
}

-(id) initWithLevelIndex:(int)lvl locked:(BOOL)locked normal:(NSString*)normal selected:(NSString*)selected {
	
	if (locked) {
		if ((self = [super initFromNormalImage:normal selectedImage:selected disabledImage:normal target:self selector:nil])) {
			
			iLvlIndex = lvl;
			isLocked = locked;
		
		//if (locked)
		//	[super initFromNormalImage:normal selectedImage:selected disabledImage:normal target:self selector:nil];
		
		}
	} else {
		//[super itemFromNormalImage:normal selectedImage:selected target:self selector:nil];
		if ((self = [super initFromNormalImage:normal selectedImage:selected disabledImage:normal target:self selector:nil])) {
			
			iLvlIndex = lvl;
			isLocked = locked;
			
		}
	}
	
	return (self);
}

-(void) onSelected:(id)sender {
    NSLog(@"LvlBtnSprite.onSelected(%d)", iLvlIndex);
    
	[ScreenManager goPlay:iLvlIndex];
}
	
@end
