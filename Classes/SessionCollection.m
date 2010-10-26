//
//  SessionCollection.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionCollection.h"

#import "SessionProtocol.h"
#import "SessionHelper.h"

@interface SessionCollection()

- (NSArray *) getUniqueBeginTimes;
- (BOOL)timesList:(NSArray*)array containsTime:(NSDate*)time;
- (BOOL)timesList:(NSArray *)array containsDay:(NSDate *)time;
- (NSArray *)getUniqueDays;

@end


@implementation SessionCollection

- (SessionCollection*) init {
	self = [super init];
	
	sessions = [[NSMutableArray alloc] initWithCapacity:20];
	
	return self;
}

- (unsigned int) count {
	return [sessions count];
}

- (void) addSession:(id <SessionProtocol>)session {
	[sessions addObject:session];
}

- (SessionCollection *) getSessionsOnDay:(NSDate *)day {
	SessionCollection *collection = [[[SessionCollection alloc] init] autorelease];
	
	for (unsigned int i = 0; i < sessions.count; i++) {
		id <SessionProtocol> session = [sessions objectAtIndex:i];
		
		if ([SessionHelper session:session isOnDay:day]) {
			[collection addSession:session];
		}
	}
	
	return collection;
}

- (id <SessionProtocol>) getSessionAt:(unsigned int)index {
	return [sessions objectAtIndex:index];
}


- (NSArray *) getUniqueBeginTimes {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (unsigned int i = 0; i < [sessions count]; i++) {
		NSDate *date = ((id<SessionProtocol>)[sessions objectAtIndex:i]).startTime;
		if (![self timesList:array containsTime:date]) {
			[array addObject:date];
		}
	}
	
	[array sortUsingSelector:@selector(compare:)];
	
	return array;
}
	 

- (BOOL)timesList:(NSArray*)array containsTime:(NSDate*)time {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	for (unsigned int i = 0; i < array.count; i++) {		
		unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
		NSDateComponents *left = [calendar components:unitFlags fromDate:time];
		NSDateComponents *right = [calendar components:unitFlags fromDate:[array objectAtIndex:i]];
		
		if ([left hour] == [right hour] && [left minute] == [right minute]) {
			return YES;
		}
	}
	
	return NO;
}


- (NSArray *) getStartTimeStrings {
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSArray *dateArray = [self getUniqueBeginTimes];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"h:mm a";
	
	for (unsigned int i = 0; i < [dateArray count]; i++) {
		[array addObject:[formatter stringFromDate:[dateArray objectAtIndex:i]]];
	}
	
	[formatter release];
	[dateArray release];
	
	return array;
}


- (SessionCollection *) getSessionsAtTime:(NSDate *)time {
	SessionCollection *array = [[[SessionCollection alloc] init] autorelease];
	
	for (unsigned int i = 0; i < [sessions count]; i++) {
		id<SessionProtocol> session = [sessions objectAtIndex:i];
		if ([SessionHelper session:session isAtTime:time]) {
			[array addSession:session];
		}
	}
	
	return array;
}


- (SessionCollection *) getSessionsUserIsAttending {
	SessionCollection *array = [[[SessionCollection alloc] init] autorelease];
	
	for (unsigned int i = 0; i < [sessions count]; i++) {
		id<SessionProtocol> session = [sessions objectAtIndex:i];
		if ([session.attending boolValue]) {
			[array addSession:session];
		}
	}
	
	return array;
}


- (NSArray *) getDayStartTimeStrings {
	NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"ccc MMM d, yyyy";
	NSArray *days = [self getUniqueDays];
	
	for (unsigned int i = 0; i < days.count; i++) {
		[array addObject:[formatter stringFromDate:[days objectAtIndex:i]]];
	}
	
	[formatter release];
	return array;
}

- (NSArray *)getUniqueDays {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (unsigned int i = 0; i < [sessions count]; i++) {
		NSDate *date1 = ((id<SessionProtocol>)[sessions objectAtIndex:i]).startTime;
		NSDate *date2 = ((id<SessionProtocol>)[sessions objectAtIndex:i]).endTime;
		if (![self timesList:array containsDay:date1]) {
			NSLog(@"Adding %@", date1);
			[array addObject:date1];
		}
		if (![self timesList:array containsDay:date2]) {
			NSLog(@"Adding %@", date2);
			[array addObject:date2];
		}
	}
	
	[array sortUsingSelector:@selector(compare:)];
	
	return array;
}


- (BOOL)timesList:(NSArray *)array containsDay:(NSDate *)time {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	for (unsigned int i = 0; i < array.count; i++) {		
		unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
		NSDateComponents *left = [calendar components:unitFlags fromDate:time];
		NSDateComponents *right = [calendar components:unitFlags fromDate:[array objectAtIndex:i]];
		
		if ([left year] == [right year] && [left month] == [right month] && [left day] == [right day]) {
			return YES;
		}
	}
	
	return NO;
}


- (void) dealloc {
	[sessions release];
	[super dealloc];
}

@end
