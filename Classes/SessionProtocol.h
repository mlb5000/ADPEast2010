//
//  SessionProtocol.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TrackProtocol;

@protocol SessionProtocol<NSObject>

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * attending;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet* speakers;
@property (nonatomic, retain) id <TrackProtocol> track;

@end
