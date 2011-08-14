//
//  AlgebraUtils.m
//  GutzTest
//
//  Created by Gullinbursti on 06/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlgebraUtils.h"

//static AlgebraUtils *insAlgebraUtils = nil;
static AlgebraUtils *singleton = nil;

@implementation AlgebraUtils

+(AlgebraUtils *) singleton {
	
	if (!singleton) {
		if ([[AlgebraUtils class] isEqual:[self class]])
			singleton = [[AlgebraUtils alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	return (singleton);
}

-(float) expo:(float)raiseTo base:(float)base {
	
	float res = 1.0f;
	BOOL isNeg = NO;
	
	if (raiseTo < 0) {
		isNeg = YES;
		raiseTo *= -1;
	}
	
	
	for (int i=0; i<raiseTo; i++)
		res *= base;
	
	if (isNeg)
		res = 1 / res;
	
	return (res);
}

-(float) pow10:(float)exp {
	return ([self expo:10.0f base:exp]);
}

-(float) half:(float)val {
	return (val * 0.5f);
}

-(float) third:(float)val {
	return (val * (1.0f / 3.0f));
}

-(float) quarter:(float)val {
	return (val * 0.25f);	
}

-(float) eigth:(float)val {
	return (val * 0.125f);	
}

-(float) dbl:(float)val {
	return (val * 2);
}

-(float) tripl:(float)val {
	return (val * 3);
}

-(float) quad:(float)val {
	return (val * 4);
}

-(float) square:(float)val {
	return ([self expo:2 base:val]);
}

-(float) cube:(float)val {
	return ([self expo:3 base:val]);
}

-(float) sqrt:(float)val {
	return ([self expo:0.5f base:val]);
}

-(float) tenFold:(float)val {
	return (val * 10);
}

-(BOOL) isEven:(int)val {
	
	if (val % 2 == 0)
		return (YES);
	
	return (NO);
}

@end
