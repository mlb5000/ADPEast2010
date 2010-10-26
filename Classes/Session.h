//
//  Session.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SessionProtocol.h"

@protocol SpeakerProtocol;
@protocol TrackProtocol;

@interface Session :  NSManagedObject <SessionProtocol> 
{
	NSDate * startTime;
	NSString * blurb;
	NSNumber * rating;
	NSNumber * attending;
	NSDate * endTime;
	NSString * title;
	NSSet* speakers;
	id <TrackProtocol> track;
}

- (NSString *)startTimeString;
- (NSString *)dayString;

@end


@interface Session (CoreDataGeneratedAccessors)
- (void)addSpeakersObject:(id <SpeakerProtocol>)value;
- (void)removeSpeakersObject:(id <SpeakerProtocol>)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

@end

