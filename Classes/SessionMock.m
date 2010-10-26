//
//  SessionMock.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionMock.h"

#import "TrackProtocol.h"
#import "SpeakerProtocol.h"

@implementation SessionMock

@synthesize startTime;
@synthesize blurb;
@synthesize rating;
@synthesize attending;
@synthesize endTime;
@synthesize title;
@synthesize speakers;
@synthesize track;

- (SessionMock *) init {
	self = [super init];
	
	speakers = [[NSSet alloc] init];
	
	return self;
}

- (void) dealloc {
	[speakers release];
	[track release];
	[startTime release];
	[blurb release];
	[rating release];
	[attending release];
	[endTime release];
	[title release];
	
	[super dealloc];
}

@end
