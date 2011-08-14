//
//  DataTypeUtils.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataTypeUtils.h"


static DataTypeUtils *singleton = nil;

@implementation DataTypeUtils

+(DataTypeUtils *) singleton {
	
	if (!singleton) {
		
		if ([[DataTypeUtils class] isEqual:[self class]])
			singleton = [[DataTypeUtils alloc] init];
		
		else
			singleton = [[self alloc] init];
	}
	
	return (singleton);
}

-(BOOL) boolFromChar:(char *)val {
	NSLog(@"::::::[%@]::::", val);
	return  ([[[NSString stringWithFormat:[NSString stringWithUTF8String:val], @"%c"] uppercaseString] isEqualToString:CHAR_TRUE]);
}


-(BOOL) boolFromInt:(int)val {
	return (val == 1);
}

-(BOOL) boolFromNote:(NSNotification *)notification {
	return ([self boolFromNumber:[self numberFromNote:notification]]);
}

-(BOOL) boolFromNumber:(NSNumber *)val {
	return ([val isEqualToNumber:[NSNumber numberWithBool:YES]]);
}


-(char) charFromBool:(BOOL)val {
	if (val)
		return ([[NSString stringWithString:CHAR_TRUE] charValue]);
	
	return  ([[NSString stringWithString:CHAR_FALSE] charValue]);
}


//-(char) charFromBinary:(NSData *)byte {
//		
//	char bufSize[FMT_BUF_SIZE];
//	printf("%s\n", [NSData (x, bufSize));
//	
//	
//}


-(int) intFromBool:(BOOL)val {
	return ((int)[NSNumber numberWithBool:val]);
}

-(NSNumber *) numberFromBool:(BOOL)val {
	
	return ([NSNumber numberWithBool:val]);
}

-(NSNumber *) numberFromNote:(NSNotification *)notification {
	return ((NSNumber *)[notification object]);
}

@end
