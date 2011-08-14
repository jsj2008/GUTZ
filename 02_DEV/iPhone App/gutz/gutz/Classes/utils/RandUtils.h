//
//  RandUtils.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RandUtils : NSObject {
    
}

+(RandUtils *) singleton;


-(int) diceRoller:(int)sides;
-(int) randIndex:(int)max;

@end
