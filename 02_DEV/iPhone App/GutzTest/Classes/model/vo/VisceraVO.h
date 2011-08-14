//
//  VisceraVO.h
//  GutzTest
//
//  Created by Gullinbursti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "chipmunk.h"

@interface VisceraVO : NSObject {
	
	int ind;
	
	CGPoint pos;
	CGPoint ang;
	CGPoint offset;
	
	cpBody *body;
	cpShape *shape;
	
	cpConstraint *sJointCore;
	cpConstraint *dSpringCore;
	
	NSMutableArray *innerJoints;
}


@property (nonatomic) int ind;

@property (nonatomic) CGPoint pos;
@property (nonatomic) CGPoint ang;
@property (nonatomic) CGPoint offset;

@property (nonatomic) cpShape *shape;
@property (nonatomic) cpBody *body;

@property (nonatomic) cpConstraint *sJointCore;
@property (nonatomic) cpConstraint *dSpringCore;

@property (nonatomic, retain) NSMutableArray *innerJoints;


+ (id)initWithData:(int)idx coords:(CGPoint)loc angle:(CGPoint)coreAngle offset:(CGPoint)coreOffset shape:(cpShape *)s body:(cpBody *)b sJointCore:(cpConstraint *)sjCore dSpringCore:(cpConstraint *)dsCore;
+ (id)initWithData:(int)idx coords:(CGPoint)loc angle:(CGPoint)coreAngle offset:(CGPoint)coreOffset shape:(cpShape *)s body:(cpBody *)b sJointCore:(cpConstraint *)sjCore dSpringCore:(cpConstraint *)dsCore innerJoints:(NSMutableArray *)joints;
+ (BOOL)attachInnerJoints:(NSMutableArray *)joints;

@end
