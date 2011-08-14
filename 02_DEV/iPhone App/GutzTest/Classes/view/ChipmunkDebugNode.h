//
//  ChipmunkDebugNode.h
//  AngryChipmunks
//
//  Created by Scott Lembcke on 11/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

//#define LINE_COLOR 0.0f, 0.0f, 0.0f
#define LINE_COLOR 0.0f, 0.1f, 0.6f


@interface ChipmunkDebugNode : CCNode {
	ChipmunkSpace *space;
}

@property (retain) ChipmunkSpace *space;

+ debugNodeForSpace:(ChipmunkSpace *)space;

@end
