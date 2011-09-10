//
//  CreatureVO.h
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCSprite.h"
#import "chipmunk.h"


@interface CreatureNodeVO : NSObject {
    
	int ind;
	float ang;
	
	CCSprite *sprite;
	cpBody *body;
	cpShape *shape;
	
	CGPoint posPt;
}

+(id) initWithData:(int)index angPos:(float)angle nodeSprite:(CCSprite *)segSprite body:(cpBody *)b shape:(cpShape *)s pos:(CGPoint)segPos;

@property (nonatomic) int ind;
@property (nonatomic) float ang;
@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic) cpBody *body;
@property (nonatomic) cpShape *shape;
@property (nonatomic) CGPoint posPt;

@end
