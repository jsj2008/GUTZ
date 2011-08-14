//
//  BasePlistParser.h
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RESRC_TYPE @"plist"


@interface BasePlistParser : NSObject {
    
	NSString *strResourcePath;
	NSString *strResourceFile;
	NSString *strFullPath;
	
	NSData *dataResourceFile;
	
	NSMutableDictionary *dicTopLvl;
	NSArray *arrItmEntries;
}


//-(id)init;
-(id) initWithFile:(NSString *)filename path:(NSString *)filepath;


-(BOOL) overwriteFile: (NSString *)filename plist:(NSDictionary *)plist;

-(void) updContentsByKey:(NSString *)key_id val:(id)data;

-(BOOL) writeBoolByKey:(NSString *)key_id val:(BOOL)data;
-(BOOL) writeNumberByKey:(NSString *)key_id val:(NSNumber *)data;
-(BOOL) writeIntByKey:(NSString *)key_id val:(int)data;
-(BOOL) writeArrayByKey:(NSString *)key_id val:(NSArray *)data;
-(BOOL) writeStringByKey:(NSString *)key_id val:(NSString *)data;
-(BOOL) writeDictByKey:(NSString *)key_id val:(NSDictionary *)data;

-(BOOL) updBinaryData;
-(BOOL) writeToFile;


@property (nonatomic, retain) NSString *strResourcePath;
@property (nonatomic, retain) NSString *strResourceFile;
@property (nonatomic, retain) NSString *strFullPath;
@property (nonatomic, retain) NSData *dataResourceFile;
@property (nonatomic, retain) NSMutableDictionary *dicTopLvl;
@property (nonatomic, retain) NSArray *arrItmEntries;

@end
