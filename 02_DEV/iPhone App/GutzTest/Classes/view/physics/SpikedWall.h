//
//  SpikedWall.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.22.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseWall.h"
#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

@interface SpikedWall : BaseWall <ChipmunkObject> {
	int spikes;
	
	int angle;
	
	ChipmunkBody *_spikedBody;
	ChipmunkPolyShape *_spikedShape;
}

-(id)initAtPos:(CGPoint)pos large:(BOOL)isLarge spikes:(int)spiked rotation:(int)ang friction:(float)fric bounce:(float)bnc;

@end
