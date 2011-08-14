//
//  VisceraVO.m
//  GutzTest
//
//  Created by Gullinbursti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VisceraVO.h"


@implementation VisceraVO

@synthesize ind;
@synthesize pos;
@synthesize ang;
@synthesize offset;
@synthesize shape;
@synthesize body;
@synthesize sJointCore;
@synthesize dSpringCore;

@synthesize innerJoints;


+ (id)initWithData:(int)idx coords:(CGPoint)loc angle:(CGPoint)coreAngle offset:(CGPoint)coreOffset shape:(cpShape *)s body:(cpBody *)b sJointCore:(cpConstraint *)sjCore dSpringCore:(cpConstraint *)dsCore {
	
	VisceraVO *vo = [[[VisceraVO alloc] init] autorelease];
	
	vo.ind = idx;
	vo.pos = loc;
	
	vo.ang = coreAngle;
	vo.offset = coreOffset;
	
	vo.shape = s;
	vo.body = b;
	
	vo.sJointCore = sjCore;
	vo.dSpringCore = dsCore;
	
	
	return (vo);
}

+ (id)initWithData:(int)idx coords:(CGPoint)loc angle:(CGPoint)coreAngle offset:(CGPoint)coreOffset shape:(cpShape *)s body:(cpBody *)b sJointCore:(cpConstraint *)sjCore dSpringCore:(cpConstraint *)dsCore innerJoints:(NSMutableArray *)joints {
	
	VisceraVO *vo = [[[VisceraVO alloc] init] autorelease];
	vo.innerJoints = [[NSMutableArray alloc] init];
	
	vo.ind = idx;
	vo.pos = loc;
	
	vo.ang = coreAngle;
	vo.offset = coreOffset;
	
	vo.shape = s;
	vo.body = b;
	
	vo.sJointCore = sjCore;
	vo.dSpringCore = dsCore;
	
	
	for (int i=0; i<[joints count]; i++)
		[vo.innerJoints addObject:[joints objectAtIndex:i]];
	
	
	return (vo);
}

+ (BOOL)attachInnerJoints:(NSMutableArray *)joints {

	return (YES);
}



@end
