//
//  Speaker.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SpeakerProtocol.h"

@protocol SessionProtocol;

@interface Speaker :  NSManagedObject<SpeakerProtocol>  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSSet* sessions;

@end


@interface Speaker (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(id <SessionProtocol>)value;
- (void)removeSessionsObject:(id <SessionProtocol>)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

