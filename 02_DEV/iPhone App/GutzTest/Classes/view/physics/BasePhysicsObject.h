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



@interface BasePhysicsObject : NSObject <ChipmunkObject> {
    
	NSSet *chipmunkObjects;
	
	ChipmunkBody *_body;
	ChipmunkShape *_shape;
	
}


@property (readonly) NSSet *chipmunkObjects;


@end
