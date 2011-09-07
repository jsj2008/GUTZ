//
//  BasePhysicsLayer.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseScreenLayer.h"

#import "ObjectiveChipmunk.h"
#import "JellyBlob.h"

@interface BasePhysicsLayer : BaseScreenLayer {
	
	ChipmunkSpace *_space;
	JellyBlob *_accBlob1;
	JellyBlob *_accBlob2;
	JellyBlob *_accBlob3;
	JellyBlob *_accBlob4;
}

-(id)initWithBackround:(NSString *)asset;
-(id)initWithBackround:(NSString *)asset position:(CGPoint)pos;

-(void)setupChipmunk;
-(void)physicsStepper:(ccTime)dt;
-(void)mobWiggler:(id)sender;

@end
