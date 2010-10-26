//
//  SessionDetailProtocol.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionProtocol.h"

@protocol SpeakerDetailProtocol;

@protocol SessionDetailProtocol<NSCoding, NSObject>

@property (nonatomic, retain) id <SessionProtocol> session;
@property (nonatomic, retain) id <SpeakerDetailProtocol> speakerDetailController;

@end
