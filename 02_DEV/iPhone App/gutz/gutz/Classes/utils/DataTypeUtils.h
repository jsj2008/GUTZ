//
//  DataTypeUtils.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CHAR_TRUE @"Y"
#define CHAR_FALSE @"N"

#define NUM_TRUE 1
#define NUM_FALSE 0

@interface DataTypeUtils : NSObject {
    
}

+(DataTypeUtils *) singleton;

-(BOOL) boolFromChar:(char *)val;
-(BOOL) boolFromInt:(int)val;
-(BOOL) boolFromNote:(NSNotification *)notification;
-(BOOL) boolFromNumber:(NSNumber *)val;

-(char) charFromBool:(BOOL)val;
//-(char) charFromBinary:(NSData *)byte;


-(int) intFromBool:(BOOL)val;

-(NSNumber *) numberFromBool:(BOOL)val;
-(NSNumber *) numberFromNote:(NSNotification *)notification;
@end

