//
//  AlgebraUtils.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlgebraUtils : NSObject {
	
}

//+(AlgebraUtils *) insAlgebraUtils;
+(AlgebraUtils *) singleton;

-(float) expo:(float)factor base:(float)base;
-(float) pow10:(float)exp;
-(float) half:(float)val;
-(float) third:(float)val;
-(float) quarter:(float)val;
-(float) eigth:(float)val;
-(float) sqrt:(float)val;
-(float) dbl:(float)val;
-(float) tripl:(float)val;
-(float) quad:(float)val;
-(float) square:(float)val;
-(float) cube:(float)val;
-(float) tenFold:(float)val;

-(BOOL) isEven:(int)val;
@end
