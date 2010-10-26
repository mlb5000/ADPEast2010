//
//  SessionCollection.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SessionProtocol;

@interface SessionCollection : NSObject {
	NSMutableArray *sessions;
}

@property (readonly) unsigned int count;

- (void) addSession:(id <SessionProtocol>)session;
- (id <SessionProtocol>) getSessionAt:(unsigned int)index;
- (SessionCollection *) getSessionsAtTime:(NSDate *)time;
- (SessionCollection *) getSessionsOnDay:(NSDate *)day;
- (SessionCollection *) getSessionsUserIsAttending;

- (NSArray *) getDayStartTimeStrings;
- (NSArray *) getStartTimeStrings;

@end
