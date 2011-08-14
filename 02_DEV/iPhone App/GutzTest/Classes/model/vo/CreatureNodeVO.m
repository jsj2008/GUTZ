//
//  CreatureNodeVO.m
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreatureNodeVO.h"


@implementation CreatureNodeVO

@synthesize ind;
@synthesize ang;
@synthesize sprite;
@synthesize body;
@synthesize shape;
@synthesize posPt;

+(id) initWithData:(int)index angPos:(float)angle nodeSprite:(CCSprite *)segSprite body:(cpBody *)b shape:(cpShape *)s pos:(CGPoint)segPos {
	
	
	CreatureNodeVO *vo = [[[CreatureNodeVO alloc] init] autorelease];
	vo.ind = index;
	vo.ang = angle;
	vo.sprite = segSprite;
	vo.body = b;
	vo.shape = s;
	vo.posPt = segPos;
	
	return (vo);
}

@end
