//
//  GeomUtils.m
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeomUtils.h"

static GeomUtils *singleton = nil;


@implementation GeomUtils

+(GeomUtils *)singleton {
	
	if (!singleton) {
		
		if ([[GeomUtils class] isEqual:[self class]])
			singleton = [[GeomUtils alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	return (singleton);
}


-(float)polygonArea:(NSArray *)arrVerts {
	
	int i;
	float area = 0.0f;
	int tot = [arrVerts count];
		
	for (i=0; i<tot; i++) {
		cpVect ptCurr = [[arrVerts objectAtIndex:i] pos];
		cpVect ptNext = [[arrVerts objectAtIndex:((i+1) % (tot-1))] pos];
		
		area += ((ptCurr.y - ptNext.y) * (ptCurr.x + ptNext.x));
	}
	
	area *= -0.5f;
	return (area);
}

@end
