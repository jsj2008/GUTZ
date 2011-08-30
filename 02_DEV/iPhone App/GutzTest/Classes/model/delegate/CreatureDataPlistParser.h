//
//  CreatureDataPlistParser.h
//  GutzTest
//
//  Created by Matthew Holcombe on 08.29.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePlistParser.h"

@interface CreatureDataPlistParser : BasePlistParser {
	
	NSArray *arrCircles;
	NSArray *arrJoints;
	
	CGPoint *ptSize;
	
	int width;
	int height;
}

-(id) initWithLevel:(int)ind;

@property (nonatomic, retain) NSArray *arrCircles;
@property (nonatomic, retain) NSArray *arrJoints;

@property (nonatomic) int width;
@property (nonatomic) int height;

@end
