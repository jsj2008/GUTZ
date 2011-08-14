//
//  LvlBtnSprite.h
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"


@interface LvlBtnSprite : CCMenuItemImage {
	int iLvlIndex;
	BOOL isLocked;
}


-(id) initWithLevelIndex:(int)lvl locked:(BOOL)locked normal:(NSString*)normal selected:(NSString*)selected;

@property (nonatomic, readwrite) int iLvlIndex;
@end
