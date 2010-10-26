//
//  SessionHelper.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionHelper.h"
#import "SessionProtocol.h"

@interface SessionHelper ()

+ (BOOL)session:(id <SessionProtocol>)session startsOn:(NSDate*)day;
+ (BOOL)session:(id <SessionProtocol>)session continuesOn:(NSDate*)day;
+ (BOOL)day:(NSDateComponents*)dayComponents isAfterStartTime:(NSDateComponents *)startComponents;

@end


@implementation SessionHelper


+ (BOOL) session:(id <SessionProtocol>)session isAtTime:(NSDate *)time {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSHourCalendarUnit|NSMinuteCalendarUnit;
	NSDateComponents *left = [calendar components:unitFlags fromDate:time];
	NSDateComponents *right = [calendar components:unitFlags fromDate:session.startTime];
	
	return (([left hour] == [right hour]) && ([left minute] == [right minute]));
}


+ (BOOL) session:(id <SessionProtocol>)session isOnDay:(NSDate *)day {
	return ([self session:session startsOn:day] || [self session:session continuesOn:day]);
}


+ (BOOL) session:(id <SessionProtocol>)session startsOn:(NSDate*)day {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSMonthCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit;
	NSDateComponents *left = [calendar components:unitFlags fromDate:day];
	NSDateComponents *right = [calendar components:unitFlags fromDate:session.startTime];
	
	return ([left year] == [right year]) && ([left month] == [right month]) && ([left day] == [right day]);
}


+ (BOOL) session:(id <SessionProtocol>)session continuesOn:(NSDate*)day {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSMonthCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit;
	NSDateComponents *left = [calendar components:unitFlags fromDate:day];
	NSDateComponents *startComponents = [calendar components:unitFlags fromDate:session.startTime];
	NSDateComponents *endComponents = [calendar components:unitFlags fromDate:session.endTime];
	
	if ((![self day:left isAfterStartTime:startComponents]) ||
		([self day:left isAfterStartTime:endComponents])) {
		return NO;
	}
	
	return YES;
}


+ (BOOL)day:(NSDateComponents *)dayComponents isAfterStartTime:(NSDateComponents *)startComponents {
	return (([dayComponents year] > [startComponents year]) ||
		([dayComponents month] > [startComponents month]) ||
		([dayComponents day] > [startComponents day]));
}


@end