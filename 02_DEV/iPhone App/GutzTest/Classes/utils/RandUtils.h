//
//  RandUtils.h
//  GutzTest
//
//  Created by Gullinbursti on 07/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARC4RANDOM_MAX 0x100000000

@interface RandUtils : NSObject {
    
}

+(RandUtils *) singleton;


-(BOOL)coinFlip;
-(int)diceRoller:(int)sides;

-(uint)rndBit;
-(BOOL)rndBool;
-(int)rndSigned;
-(int)rndIndex:(int)max;
-(int)rndInt:(int)lower max:(int)upper;
-(float)rndFloat:(float)lower max:(float)upper;
-(float)rndFloat:(float)lower max:(float)upper decimals:(int)prec;


@end
