//
//  BasePhysicsObject.h
//  GutzTest
//
//  Created by Gullinbursti on 08/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

#define INACTIVE_LAYER 69
#define NORMAL_LAYER 1
#define GRABABLE_LAYER 2

#define EDGE_BOUNCE 0.5f
#define EDGE_FRICTION 0.1f

@interface BasePhysicsObject : NSObject <ChipmunkObject> {
    
	NSSet *chipmunkObjects;
	NSMutableSet *set;
	ChipmunkSpace *_space;
	
	ChipmunkBody *_body;
	ChipmunkShape *_shape;
	
	cpVect _ptPos;
	
	int _totBodies;
}

-(void)spaceRef:(ChipmunkSpace *)space;

@property (nonatomic, readonly) NSSet *chipmunkObjects;
//@property (readonly) NSSet *chipmunkObjects;


@end
