//
//  StiffGibs.h
//  GutzTest
//
//  Created by Matthew Holcombe on 08.12.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "BaseGibs.h"

@interface StiffGibs : BaseGibs <ChipmunkObject> {
	
}

-(id)initAtPos:(CGPoint)pos;

@end
