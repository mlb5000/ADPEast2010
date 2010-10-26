//
//  Track.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TrackProtocol.h"

@protocol SessionProtocol;

@interface Track :  NSManagedObject <TrackProtocol>
{
	NSString * name;
	NSSet* sessions;
}

@end


@interface Track (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(id <SessionProtocol>)value;
- (void)removeSessionsObject:(id <SessionProtocol>)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

