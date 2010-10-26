//
//  SpeakerProtocol.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SpeakerProtocol<NSObject>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * blurb;
@property (nonatomic, retain) NSSet* sessions;
@property (nonatomic, retain) NSData* image;

@end
