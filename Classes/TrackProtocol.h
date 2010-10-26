//
//  TrackProtocol.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TrackProtocol<NSObject>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* sessions;

@end
