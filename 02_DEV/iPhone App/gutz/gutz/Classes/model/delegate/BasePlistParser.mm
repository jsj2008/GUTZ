//
//  BasePlistParser.mm
//  gutz
//
//  Created by Gullinbursti on 07/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BasePlistParser.h"


@implementation BasePlistParser

@synthesize strResourcePath;
@synthesize strResourceFile;
@synthesize strFullPath;
@synthesize dataResourceFile;

@synthesize dicTopLvl;
@synthesize arrItmEntries;


-(id) initWithFile:(NSString *)filename path:(NSString *)filepath {
	NSLog(@"-/> %@.%@(\"%@\") </-", [self class], @"initWithFile", filename);
	
	if ((self = [super init])) {
		
		// set the filename
		
		if ([filepath length] == 0)
			filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
		strResourcePath = [filepath stringByAppendingString:@"/"];
		strResourceFile = filename;
		NSLog(@"  -/> %@.strResourceFile:[\"%@\"], type:[%@]) </-", [self class], strResourceFile, RESRC_TYPE);	
		
		strFullPath = [[NSBundle mainBundle] pathForResource:strResourceFile ofType:RESRC_TYPE];
		//strFullPath = [[strResourcePath stringByAppendingString:strResourceFile] stringByAppendingPathExtension:RESRC_TYPE];
		NSLog(@"-/> %@.strFullPath:[%@]) </-", [self class], strFullPath);	
		
		dicTopLvl = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strResourceFile ofType:RESRC_TYPE]];
		//NSLog(@"-/> %@.dicTopLvl:[%@]) </-", [self class], [dicTopLvl allKeys]);	
		
		[self updBinaryData];
		
		//dataResourceFile = [[NSFileManager defaultManager] contentsAtPath:strFullPath];
		
		// pull out plist entries into array
		arrItmEntries = [[[self dicTopLvl] allKeys] sortedArrayUsingSelector:@selector(compare:)];
		
		//for (int i=0; i<[arrItmEntries count]; i++) {
		//	NSLog(@"  -/> arrItems[%d]=(%@) </-", i, [arrItmEntries objectAtIndex:i]);
		//}
	}
	
	return (self);
	
	
	
	//[[self dicTopLvl] allValues]
}




-(BOOL) writeNumberByKey:(NSString *)key_id val:(NSNumber *)data {
	
	[self updContentsByKey:key_id val:data];
	
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
}



-(BOOL) writeIntByKey:(NSString *)key_id val:(int)data {
	
	[self updContentsByKey:key_id val:(id)data];
	
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
}


-(BOOL) writeBoolByKey:(NSString *)key_id val:(BOOL)data {
	
	[self updContentsByKey:key_id val:[NSNumber numberWithBool:data]];
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
}


-(BOOL) writeStringByKey:(NSString *)key_id val:(NSString *)data {
	
	[self updContentsByKey:key_id val:data];
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
}


-(BOOL) writeDictByKey: (NSString *)key_id val:(NSDictionary *)data {
	
	[self updContentsByKey:key_id val:data];
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
}


-(BOOL) writeArrayByKey:(NSString *)key_id val:(NSArray *)data {
	
	[self updContentsByKey:key_id val:data];
	
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
	
}


-(BOOL) writeStringByKey:(NSString *)filename key:(NSString *)key_id val:(NSString *)data {
	
	[self updContentsByKey:key_id val:data];
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
}


-(BOOL) writeDictByKey:(NSString *)filename key:(NSString *)key_id val:(NSDictionary *)data {
	
	[self updContentsByKey:key_id val:data];
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	
	return (NO);
	
}

-(void) updContentsByKey:(NSString *)key_id val:(id)data {
	
	[dicTopLvl setValue:data forKey:key_id];
	NSLog(@"-/> %@.updContentsByKey:[%@]) </-", [self class], dicTopLvl);
	
}

-(BOOL) overwriteFile:(NSString *)filename plist:(NSDictionary *)dict {
	
	dicTopLvl = [[NSDictionary alloc] initWithDictionary:dict];
	
	if ([self updBinaryData] && [self writeToFile])
		return (YES);
	
	return (NO);
}


-(BOOL) updBinaryData {
	//NSLog(@"-/> %@.updBinaryData:(%@) </-", [self class], dataResourceFile);
	
	NSString* error;
	
	return (YES);
	
	dataResourceFile = [NSPropertyListSerialization dataFromPropertyList:dicTopLvl format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	if (dataResourceFile)
        return (YES);
	
	else {
        NSLog(@"%@", error);
		[error release];	}
	
	//rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	//plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
	//dataResourceFile = [[NSFileManager defaultManager] contentsAtPath:strFullPath];
	
	return (NO);
}

-(BOOL) writeToFile {
	NSLog(@"-/> %@.writeToFile:(%@) </-", [self class], strResourceFile);
	
	NSString* error;
	
	strFullPath = [[NSBundle mainBundle] pathForResource:strResourceFile ofType:RESRC_TYPE];
	dataResourceFile = [NSPropertyListSerialization dataFromPropertyList:dicTopLvl format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	//if ([dataResourceFile writeToFile:strFullPath atomically:YES])
	if ([dicTopLvl writeToFile:strFullPath atomically:YES])
        return (YES);
	
	else {
        NSLog(@"%@", error);
		[error release];
	}
	
	return (NO);
}
@end


// load up the plist
//NSDictionary *dicContents = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Links" ofType:@"plist"]];
//NSLog(@"-/> %@.dicContents:[%@]) </-", @"BasePlistParser", [dicContents count]);	





//-(void)readPList:(NSString *)filePath filename:(NSString *)filename {
//	
//	NSString *personName;
//    NSMutableArray *phoneNumbers;
//	
//	NSString *errorDesc = nil;
//	NSPropertyListFormat format;
//	
//	
//	//NSString *rootPath = [[NSString alloc] initWithString:@"/Volumes/Ratatoskr/labor/clients/sthompkins/gutz/iOS/GutzTest/GutzTest/Resources/"];
//	NSString *rootPath = [[NSString alloc] initWithString:filePath];
//	
//	
//	//NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
//	NSString *plistPath = [[rootPath stringByAppendingPathComponent:filename] stringByAppendingPathComponent:@".plist"];
//	
//	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
//	NSLog(@"[%@]", plistXML);
//	
//	NSDictionary *temp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"plist"]];
//	NSLog(@"\n\n\nTEMP:[%@]", temp);
//	
//	
//	if (!temp)
//		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
//		
//		
//		personName = [temp objectForKey:@"Name"];
//		[phoneNumbers initWithArray:[NSMutableArray arrayWithArray:[temp objectForKey:@"Phones"]]];
//	
//	
//	

//NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];


//NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
//NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
//NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization dataFromPropertyList:plistXML format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];




/*
 CFPropertyListRef propertyList;
 CFURLRef fileURL;
 
 // Construct a complex dictionary object;
 propertyList = [self createDictRef];
 
 // Create a URL that specifies the file we will create to
 // hold the XML data.
 fileURL = CFURLCreateWithFileSystemPath( kCFAllocatorDefault,
 CFSTR("~/test.txt"),       // file path name
 kCFURLPOSIXPathStyle,    // interpret as POSIX path
 false );                 // is it a directory?
 
 // Write the property list to the file.
 [self writeMyPListToFile:propertyList url:fileURL];
 CFRelease(propertyList);
 
 // Recreate the property list from the file.
 propertyList = [self createPListFromFile:fileURL];
 
 // Release any objects to which we have references.
 CFRelease(propertyList);
 CFRelease(fileURL);
 */




//[self writePlist:@"John Doe" phoneNumbers:[[NSArray alloc] initWithObjects:[[NSString alloc] initWithString:@"408-974-0000"], [[NSString alloc] initWithString:@"239-514-8282"], nil] path:@"/Volumes/Ratatoskr/labor/clients/sthompkins/gutz/iOS/GutzTest/GutzTest/Resources/Data.plist"];






//	-(void) writePlist: (NSString*)personName phoneNumbers:(NSArray*)phoneNumbers path:(NSString*)plistPath {
//		
//		
//		
//		NSString *error;
//		//rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//		//plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
//		NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: personName, phoneNumbers, nil] forKeys:[NSArray arrayWithObjects: @"Name", @"Phones", nil]];
//		NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
//		
//		if(plistData) {
//			[plistData writeToFile:plistPath atomically:YES];
//			
//		} else {
//			NSLog(@"%@", error);
//			[error release];
//		}
//		
//		
//	}

