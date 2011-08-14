//
//  SegNodeSprite.m
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SegNodeSprite.h"


@implementation SegNodeSprite

@synthesize strName;

-(id) initWithPhysics:(int)index name_sp:(NSString *)n shape_ch:(cpShape *)s body_ch:(cpBody *)b {
	NSLog(@"-/> %@.%@() </-", [self class], @"initWithPhysics");
    
	if ((self = [super initWithFile:n])) {
		
		ind = index;
		strName = n;
		shape = s;
		body = b;
	}
	
	
	return (self);
}


-(cpBody *) getBody {
	return (body);
}

-(cpShape *) getShape {
	return (shape);
}

-(int) getIndex {
	return (ind);
}

@end
