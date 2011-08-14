//
//  SegNodeSprite.h
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "chipmunk.h"


@interface SegNodeSprite : CCSprite {
    
	int ind;
	NSString *strName;
	cpShape *shape;
	cpBody *body;
}


-(id) initWithPhysics:(int)index name_sp:(NSString *)n shape_ch:(cpShape *)s body_ch:(cpBody *)b;


-(int) getIndex;
-(cpBody *) getBody;
-(cpShape *) getShape;


@property (nonatomic, retain) NSString *strName;
@end
