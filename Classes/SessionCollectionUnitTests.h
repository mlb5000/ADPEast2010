//
//  SessionCollectionUnitTests.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Foundation/Foundation.h>

@class SessionCollection;

@interface SessionCollectionUnitTests : SenTestCase {
	SessionCollection * collection;
}

- (void) addSessionWithTitle:(NSString *)title;
- (void) addSessionWithTitle:(NSString *)title startTime:(NSString*)startString endTime:(NSString*)endString;
- (void) addSessionWithTitle:(NSString *)title startTime:(NSString*)startString endTime:(NSString*)endString attending:(BOOL)attending;
- (void) addSomeNormalAndMultidaySessions;

- (NSDate*) dayFromString:(NSString*)string;
@end
