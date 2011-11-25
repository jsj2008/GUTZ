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
	
	NSArray *_arrShortSpikes;
	NSArray *_arrLongSpikes;
	NSArray *_arrSpikes;
}

-(id)initAtPos:(CGPoint)pos large:(BOOL)isLarge spikes:(int)spiked rotation:(int)ang friction:(float)fric bounce:(float)bnc;
-(void)makeSpikes;

@end
