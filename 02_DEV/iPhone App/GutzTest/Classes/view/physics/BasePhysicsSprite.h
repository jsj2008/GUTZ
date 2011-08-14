//
//  BasePhysicsSprite.h
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"
#import "BasePhysicsObject.h"

@interface BasePhysicsSprite : BasePhysicsObject <ChipmunkObject> {
    CCSprite *_sprite;
}

@property (readonly) CCSprite *_sprite;

- (void)updatePosition;

@end
