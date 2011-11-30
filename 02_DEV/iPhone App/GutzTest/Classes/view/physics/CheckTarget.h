//
//  CheckTarget.h
//  GutzTest
//
//  Created by Matthew Holcombe on 11.26.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

#import "BaseTarget.h"

@interface CheckTarget : BaseTarget <ChipmunkObject> {
	
}

-(id)initAtPos:(CGPoint)pos;
-(void)updateCovered:(BOOL)covered;

@end
