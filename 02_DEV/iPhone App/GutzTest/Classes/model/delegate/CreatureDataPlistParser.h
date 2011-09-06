//
//  CreatureDataPlistParser.h
//  GutzTest
//
//  Created by Matthew Holcombe on 08.29.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePlistParser.h"

@interface CreatureDataPlistParser : BasePlistParser {
	
	NSArray *arrParts;
	NSArray *arrClamps;
	
}

-(id) initWithLevel:(int)ind;

@property (nonatomic, retain) NSArray *arrParts;
@property (nonatomic, retain) NSArray *arrClamps;


@end
