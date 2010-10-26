//
//  main.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL installDatabaseIfNotInstalled();

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	if (!installDatabaseIfNotInstalled()) {
		NSLog(@"FATAL: Could not install database.");
		return -1;
	}
	int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}

BOOL installDatabaseIfNotInstalled() {	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writablePath = [documentsDirectory stringByAppendingPathComponent:@"AgileDevPracticesEast2010.sqlite"];
	if ([fileManager fileExistsAtPath:writablePath]) {
		return YES;
	}
	NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"ADPEast2010" ofType:@"sqlite"];
	if (![fileManager copyItemAtPath:defaultDBPath toPath:writablePath error:&error]) {
		NSLog(@"Copying of database failed.");
		return NO;
	}	
	return YES;
}
