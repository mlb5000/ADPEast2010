//
//  SpeakerDetailProtocol.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakerProtocol.h"

@protocol SpeakerDetailProtocol<NSCoding, NSObject>

@property (nonatomic, retain) NSSet *speakers;

@end
