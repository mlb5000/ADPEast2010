//
//  SessionMock.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionProtocol.h"

@protocol TrackProtocol;

@interface SessionMock : NSObject <SessionProtocol> {
	NSDate * startTime;
	NSString * blurb;
	NSNumber * rating;
	NSNumber * attending;
	NSDate * endTime;
	NSString * title;
	NSSet* speakers;
	id <TrackProtocol> track;
}

@end
