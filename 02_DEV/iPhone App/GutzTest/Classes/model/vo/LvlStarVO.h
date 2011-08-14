//
//  LvlStarVO.h
//  GutzTest
//
//  Created by Gullinbursti on 07/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"



@interface LvlStarVO : NSObject {
    
	NSNumber *ind;
	NSNumber *grp;
	
	CGPoint *ptPos;
	CGPoint *ptScale;
	
	BOOL isFilled;
	
	CCSprite *starSprite;
}


@property (nonatomic, readwrite) BOOL isFilled;

@end
