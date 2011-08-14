//
//  PhysicsItemVO.m
//  GutzTest
//
//  Created by Gullinbursti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsItemVO.h"


@implementation PhysicsItemVO

@synthesize pos;
@synthesize ang;
@synthesize shape;
@synthesize body;
@synthesize sprite;



+ (id)initWithData:(CGPoint)loc angle:(float)a shape:(cpShape *)form body:(cpBody *)b sprite:(CCSprite *)s {
	
	PhysicsItemVO *vo = [[[PhysicsItemVO alloc] init] autorelease];
	
	vo.pos = loc;
	vo.ang = a;
	vo.shape = form;
	vo.body = b;
	vo.sprite = s;
	
	
	return (vo);
}


@end
