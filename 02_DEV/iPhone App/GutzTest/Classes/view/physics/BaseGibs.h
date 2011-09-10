//
//  BaseGibs.h
//  GutzTest
//
//  Created by Matthew Holcombe on 09.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePhysicsSprite.h"

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"


#define ORTHODOX_RADIUS 2
#define ORTHODOX_EDGES 8

#define ORTHODOX_GIBS_MASS 0.05f

#define ORTHODOX_FRICTION 0.9f
#define ORTHODOX_BOUNCE 0.5f

#define ORTHODOX_STIFFNESS 48.0f
#define ORTHODOX_DAMPING 1.0f
#define ORTHODOX_SQUISH 0.7f


@interface BaseGibs : BasePhysicsSprite <ChipmunkObject> {
	
	int _cntHits;
	int _cntWallHits;
	int _cntBlobHits;
	
	int _totEdges;
	int _rad;
	int _area;
	int _perimeter;
	int _radEdge;
	
	
	int _life;
	BOOL _isBroken;
	
	ChipmunkBody *_centralBody;
	ChipmunkShape *_centralShape;
	
	NSArray *_arrParts;
	NSArray *_arrClamps;
	NSMutableArray *_arrConstraints;
	NSArray *_arrEdgeBodies;
	NSMutableArray *_arrBodies;
	NSMutableArray *_arrShapes;
}

//--@property (nonatomic, retain) NSMutableArray *arrAllBodies;


-(id)initAtPos:(cpVect)pos;
-(id)initAtPos:(cpVect)pos withRadius:(int)rad;
-(id)initAtPos:(cpVect)pos withEdges:(int)amt;
-(id)initAtPos:(cpVect)pos withRadius:(int)rad withEdges:(int)amt;

-(void)assemble;
-(void)constructCenter;
-(void)constructPerimeter;

-(void)step;
-(void)step:(int)inc;

-(void)applyThrust:(cpVect)force from:(cpVect)offset edgesToo:(BOOL)isAll;

-(void)regHit:(id)obj;
-(void)draw;


-(int)lifeRemains;
-(NSArray *)arrAllBodies;
-(NSArray *)arrEdgeBodies;
-(NSDictionary *)dictAllPhysicsPairs;
-(NSDictionary *)dictEdgePhysicsPairs;
-(NSArray *)arrFixtrues;


@end
