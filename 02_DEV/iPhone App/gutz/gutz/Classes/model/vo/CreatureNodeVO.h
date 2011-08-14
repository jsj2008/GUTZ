//
//  CreatureNodeVO.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "CCSprite.h"
//#import "chipmunk.h"
#import "Box2D.h"


@interface CreatureNodeVO : NSObject {
    
	int ind;
	
	CCSprite *sprite;
	b2Body *body;
	b2PolygonShape shape;
	
	CGPoint posPt;
}

+(id) initWithData:(int)index nodeSprite:(CCSprite *)segSprite body:(b2Body *)b shape:(b2PolygonShape)s pos:(CGPoint)segPos;

@property (nonatomic) int ind;
@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic) b2Body *body;
@property (nonatomic) b2PolygonShape shape;
@property (nonatomic) CGPoint posPt;

@end
