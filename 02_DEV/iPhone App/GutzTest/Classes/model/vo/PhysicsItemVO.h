//
//  PhysicsItemVO.h
//  GutzTest
//
//  Created by Gullinbursti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "chipmunk.h"
#import "cocos2d.h"

@interface PhysicsItemVO : NSObject {
    
	CGPoint pos;
	float ang;
	cpShape *shape;
	cpBody *body;
	CCSprite *sprite;
}

@property (nonatomic) CGPoint pos;
@property (nonatomic) float ang;
@property (nonatomic) cpShape *shape;
@property (nonatomic) cpBody *body;

@property (nonatomic, retain) CCSprite *sprite;



+ (id)initWithData:(CGPoint)loc angle:(float)a shape:(cpShape *)form body:(cpBody *)b sprite:(CCSprite *)s;

@end
