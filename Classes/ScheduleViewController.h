//
//  ScheduleViewController.h
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SessionListProtocol;
@class SessionCollection;
@class SessionListViewController;

@interface ScheduleViewController : UITableViewController {
	SessionCollection *sessions;
	id <SessionListProtocol> listViewController;
}

@property (nonatomic, retain) SessionCollection *sessions;
@property (nonatomic, retain) id <SessionListProtocol> listViewController;

@end
