// 
//  Session.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Session.h"

#import "SpeakerProtocol.h"
#import "TrackProtocol.h"

@interface Session ()

- (NSString*)getStartTimeStringWithFormat:(NSString*) format;

@end

@implementation Session 

@dynamic startTime;
@dynamic blurb;
@dynamic rating;
@dynamic attending;
@dynamic endTime;
@dynamic title;
@dynamic speakers;
@dynamic track;

- (NSString *)startTimeString {	
	return [self getStartTimeStringWithFormat:@"h:mm a"];
}


- (NSString*)getStartTimeStringWithFormat:(NSString*)format {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = format;
	
	return [formatter stringFromDate:self.startTime];
}


- (NSString *)dayString {	
	return [self getStartTimeStringWithFormat:@"ccc MMM d, yyyy"];
}


@end
