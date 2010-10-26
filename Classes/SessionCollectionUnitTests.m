//
//  SessionCollectionUnitTests.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionCollectionUnitTests.h"
#import "SessionCollection.h"
#import "SessionMock.h"

#import "SessionProtocol.h"
#import "TrackProtocol.h"

@implementation SessionCollectionUnitTests

- (void) setUp {
	collection = [[SessionCollection alloc] init];
}

- (void) tearDown {
	[collection release];
}

- (void) testCount_ByDefault_IsZero {	
	STAssertEquals(collection.count, (unsigned int)0, nil);
}

- (void) testAddSession_EmptyCollection_CountEqualsOne {
	[self addSessionWithTitle:@"Session 1"];
	
	STAssertEquals(collection.count, (unsigned int)1, nil);
}

- (void) addSessionWithTitle:(NSString *)title {
	[self addSessionWithTitle:title startTime:@"2010-11-11 00:00:00 -0500" endTime:@"2010-11-12 00:00:00 -0500"];
}

- (void) testGetSessionsOnDay_NoSessionsOnGivenDay_ReturnsEmptyCollection {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd";
	NSDate *day = [formatter dateFromString:@"2010-10-14"];
	
	[self addSomeNormalAndMultidaySessions];
	
	SessionCollection *daySessions = [collection getSessionsOnDay:day];
	
	STAssertEquals(daySessions.count, (unsigned int)0, nil);
}

- (void) addSomeNormalAndMultidaySessions {
	[self addSessionWithTitle:@"Session 1" startTime:@"2010-11-14 08:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 2" startTime:@"2010-11-15 08:30:00 -0500" endTime:@"2010-11-16 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 3" startTime:@"2010-11-16 16:30:00 -0500" endTime:@"2010-11-18 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 4" startTime:@"2010-11-14 09:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 5" startTime:@"2010-11-15 13:30:00 -0500" endTime:@"2010-11-15 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 6" startTime:@"2010-11-16 09:30:00 -0500" endTime:@"2010-11-16 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 7" startTime:@"2010-11-14 10:30:00 -0500" endTime:@"2010-11-16 08:30:00 -0500"];
}

- (void) addSessionWithTitle:(NSString *)title startTime:(NSString*)startString endTime:(NSString*)endString {
	[self addSessionWithTitle:title startTime:startString endTime:endString attending:NO];
}

- (void) addSessionWithTitle:(NSString *)title startTime:(NSString*)startString endTime:(NSString*)endString attending:(BOOL)attending {
	SessionMock *session = [[SessionMock alloc] init];
	session.title = title;
	NSDate *startTime = [[NSDate alloc] initWithString:startString];
	NSDate *endTime = [[NSDate alloc] initWithString:endString];
	session.startTime = startTime;
	session.endTime = endTime;
	session.attending = [NSNumber numberWithBool:attending];
	
	[collection addSession:session];
	
	[endTime release];
	[startTime release];
	[session release];
}
- (void) testGetSessionsOnDay_NoMultidaySessionsOnDay_ReturnsCorrectSessions {	
	[self addSomeNormalAndMultidaySessions];
	
	SessionCollection *daySessions = [collection getSessionsOnDay:[self dayFromString:@"2010-11-14"]];
	
	STAssertEquals(daySessions.count, (unsigned int)3, nil);
	STAssertTrue([[daySessions getSessionAt:0].title isEqualToString:@"Session 1"], nil);
	STAssertTrue([[daySessions getSessionAt:1].title isEqualToString:@"Session 4"], nil);
	STAssertTrue([[daySessions getSessionAt:2].title isEqualToString:@"Session 7"], nil);
}

- (NSDate*) dayFromString:(NSString *)string {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"yyyy-MM-dd";
	NSDate *day = [[formatter dateFromString:string] autorelease];
	
	return day;
}

- (void) testGetSessionsOnDay_MultidaySessionsContinuingOnDay_ReturnsCorrectSessions {	
	[self addSomeNormalAndMultidaySessions];
	
	SessionCollection *daySessions = [collection getSessionsOnDay:[self dayFromString:@"2010-11-15"]];
	
	STAssertEquals(daySessions.count, (unsigned int)3, nil);
	STAssertTrue([[daySessions getSessionAt:0].title isEqualToString:@"Session 2"], nil);
	STAssertTrue([[daySessions getSessionAt:1].title isEqualToString:@"Session 5"], nil);
	STAssertTrue([[daySessions getSessionAt:2].title isEqualToString:@"Session 7"], nil);
}

- (void) testGetSessionsOnDay_MixedSingleAndMultidaySessionsOnDay_ReturnsCorrectSessions {	
	[self addSomeNormalAndMultidaySessions];
	
	SessionCollection *daySessions = [collection getSessionsOnDay:[self dayFromString:@"2010-11-16"]];
	
	STAssertEquals(daySessions.count, (unsigned int)4, nil);
	STAssertTrue([[daySessions getSessionAt:0].title isEqualToString:@"Session 2"], nil);
	STAssertTrue([[daySessions getSessionAt:1].title isEqualToString:@"Session 3"], nil);
	STAssertTrue([[daySessions getSessionAt:2].title isEqualToString:@"Session 6"], nil);
	STAssertTrue([[daySessions getSessionAt:3].title isEqualToString:@"Session 7"], nil);
}

- (void) testGetSessionsOnDay_OnlyMultidaySessionContinuingOnDay_ReturnsCorrectSessions {	
	[self addSomeNormalAndMultidaySessions];
	
	SessionCollection *daySessions = [collection getSessionsOnDay:[self dayFromString:@"2010-11-17"]];
	
	STAssertEquals(daySessions.count, (unsigned int)1, nil);
	STAssertTrue([[daySessions getSessionAt:0].title isEqualToString:@"Session 3"], nil);
}

- (void) testGetSessionsOnDay_OnlyMultidaySessionEndingOnDay_ReturnsCorrectSessions {	
	[self addSomeNormalAndMultidaySessions];
	
	SessionCollection *daySessions = [collection getSessionsOnDay:[self dayFromString:@"2010-11-18"]];
	
	STAssertEquals(daySessions.count, (unsigned int)1, nil);
	STAssertTrue([[daySessions getSessionAt:0].title isEqualToString:@"Session 3"], nil);
}

- (void) testgetStartTimeStrings_MixedSessions_ReturnsCorrectTimes {
	[self addSomeNormalAndMultidaySessions];
	
	NSArray *timeStrings = [collection getStartTimeStrings];
	
	STAssertEquals(timeStrings.count, (unsigned int)5, nil);
	STAssertEqualObjects([timeStrings objectAtIndex:0], @"8:30 AM", nil);
	STAssertEqualObjects([timeStrings objectAtIndex:1], @"9:30 AM", nil);
	STAssertEqualObjects([timeStrings objectAtIndex:2], @"10:30 AM", nil);
	STAssertEqualObjects([timeStrings objectAtIndex:3], @"1:30 PM", nil);
	STAssertEqualObjects([timeStrings objectAtIndex:4], @"4:30 PM", nil);
}


- (void) testgetSessionsAtTime_TimeMatchesMultiple_ReturnsCorrectSessions {
	[self addSomeNormalAndMultidaySessions];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"h:mm a";
	
	SessionCollection *atTime = [collection getSessionsAtTime:[formatter dateFromString:@"8:30 AM"]];
	STAssertEquals(atTime.count, (unsigned int)2, nil);
	STAssertEqualObjects([atTime getSessionAt:0].title, @"Session 1", nil);
	STAssertEqualObjects([atTime getSessionAt:1].title, @"Session 2", nil);
	
	atTime = [collection getSessionsAtTime:[formatter dateFromString:@"9:30 AM"]];	
	STAssertEquals(atTime.count, (unsigned int)2, nil);
	STAssertEqualObjects([atTime getSessionAt:0].title, @"Session 4", nil);
	STAssertEqualObjects([atTime getSessionAt:1].title, @"Session 6", nil);
	
	atTime = [collection getSessionsAtTime:[formatter dateFromString:@"4:30 PM"]];	
	STAssertEquals(atTime.count, (unsigned int)1, nil);
	STAssertEqualObjects([atTime getSessionAt:0].title, @"Session 3", nil);
	
	atTime = [collection getSessionsAtTime:[formatter dateFromString:@"4:30 AM"]];	
	STAssertEquals(atTime.count, (unsigned int)0, nil);
	
	atTime = [collection getSessionsAtTime:[formatter dateFromString:@"4:31 PM"]];	
	STAssertEquals(atTime.count, (unsigned int)0, nil);
}

- (void)testSessionsUserIsAttending_MixedList_ReturnsExpectedSessions {
	[self addSessionWithTitle:@"Session 1" startTime:@"2010-11-11 00:00:00 -0500" endTime:@"2010-11-12 00:00:00 -0500" attending:YES];
	[self addSessionWithTitle:@"Session 2" startTime:@"2010-11-11 00:00:00 -0500" endTime:@"2010-11-12 00:00:00 -0500" attending:NO];
	[self addSessionWithTitle:@"Session 3" startTime:@"2010-11-11 00:00:00 -0500" endTime:@"2010-11-12 00:00:00 -0500" attending:YES];
	[self addSessionWithTitle:@"Session 4" startTime:@"2010-11-11 00:00:00 -0500" endTime:@"2010-11-12 00:00:00 -0500" attending:NO];
	[self addSessionWithTitle:@"Session 5" startTime:@"2010-11-11 00:00:00 -0500" endTime:@"2010-11-12 00:00:00 -0500" attending:YES];

	SessionCollection *subset = [collection getSessionsUserIsAttending];
	
	STAssertEquals(subset.count, (unsigned int)3, nil);
}

- (void)testgetDayStartTimeStrings_MixedList_ReturnsExpectedStrings {
	[self addSessionWithTitle:@"Session 1" startTime:@"2010-11-14 08:30:00 -0500" endTime:@"2010-11-16 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 2" startTime:@"2010-11-14 09:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 3" startTime:@"2010-11-14 10:30:00 -0500" endTime:@"2010-11-17 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 4" startTime:@"2010-11-14 11:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 5" startTime:@"2010-11-15 08:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 6" startTime:@"2010-11-15 09:30:00 -0500" endTime:@"2010-11-17 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 7" startTime:@"2010-11-15 10:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 8" startTime:@"2010-11-15 11:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 9" startTime:@"2010-11-16 08:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 10" startTime:@"2010-11-16 09:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 11" startTime:@"2010-11-16 10:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];
	[self addSessionWithTitle:@"Session 12" startTime:@"2010-11-16 11:30:00 -0500" endTime:@"2010-11-14 08:30:00 -0500"];

	
	NSArray *array = [collection getDayStartTimeStrings];
	
	STAssertEquals(array.count, (unsigned int)4, nil);
	STAssertEqualObjects([array objectAtIndex:0], @"Sun Nov 14, 2010", nil);
	STAssertEqualObjects([array objectAtIndex:1], @"Mon Nov 15, 2010", nil);
	STAssertEqualObjects([array objectAtIndex:2], @"Tue Nov 16, 2010", nil);
	STAssertEqualObjects([array objectAtIndex:3], @"Wed Nov 17, 2010", nil);
}

@end
