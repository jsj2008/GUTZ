//
//  CreatureNodeVO.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreatureNodeVO.h"


@implementation CreatureNodeVO

@synthesize ind;
@synthesize sprite;
@synthesize body;
@synthesize shape;
@synthesize posPt;

+(id) initWithData:(int)index nodeSprite:(CCSprite *)segSprite body:(b2Body *)b shape:(b2PolygonShape)s pos:(CGPoint)segPos {
	
	
	CreatureNodeVO *vo = [[[CreatureNodeVO alloc] init] autorelease];
	vo.ind = index;
	vo.sprite = segSprite;
	vo.body = b;
	//vo.shape = s;
	vo.posPt = segPos;
	
	return (vo);
}

@end
