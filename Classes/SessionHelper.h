//
//  SessionHelper.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionProtocol.h"

@interface SessionHelper : NSObject {

}

+ (BOOL) session:(id <SessionProtocol>)session isAtTime:(NSDate *)time;
+ (BOOL) session:(id <SessionProtocol>)session isOnDay:(NSDate *)day;

@end
