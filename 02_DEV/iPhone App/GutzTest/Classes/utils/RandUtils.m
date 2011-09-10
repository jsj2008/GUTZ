//
//  RandUtils.m
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RandUtils.h"

static RandUtils *singleton = nil;

@implementation RandUtils

+(RandUtils *) singleton {
	
	if (!singleton) {
		
		if ([[RandUtils class] isEqual:[self class]])
			singleton = [[RandUtils alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	return (singleton);
	
	
	//NSLog(@"///////FLOAT(0-10):[%f]////////", [[RandUtils singleton] rndFloat:0.0f max:10.0f]);
	//NSLog(@"///////INT(0-5):[%d]////////", [[RandUtils singleton] rndInt:0 max:5]);
	//NSLog(@"///////DICE(6):[%d]////////", [[RandUtils singleton] diceRoller:6]);
	//NSLog(@"///////IND(8):[%d]////////", [[RandUtils singleton] rndIndex:8]);
	//NSLog(@"///////COIN:[%d]////////", (int)[[RandUtils singleton] coinFlip]);

	
	//double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
}


-(BOOL)coinFlip {
	return ([[RandUtils singleton] diceRoller:2] == 1);
}

-(int)diceRoller:(int)sides {
	return ((arc4random() % sides) + 1);
}

-(int)rndSigned {
	if ([[RandUtils singleton] coinFlip])
		return (1);
	
	return (-1);
}

-(uint)rndBit {
	return ([[RandUtils singleton] diceRoller:2] == 1);
}

-(BOOL)rndBool {
	return ([[RandUtils singleton] coinFlip] == 1);
}

-(int)rndIndex:(int)max {
	return ([[RandUtils singleton] rndInt:1 max:max]);
}

-(int)rndInt:(int)lower max:(int)upper {
	return ((arc4random() % (upper - lower)) + lower);
}

-(float)rndFloat:(float)lower max:(float)upper {
	return (((double)arc4random() / ARC4RANDOM_MAX) * upper);
}

-(float)rndFloat:(float)lower max:(float)upper decimals:(int)prec {
	return ([[RandUtils singleton] rndFloat:0.0f max:10.0f]);
}


@end
