//
//  SessionListViewController.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionListProtocol.h"

@protocol SessionDetailProtocol;
@class SessionCollection;

@interface SessionListViewController : UITableViewController<SessionListProtocol> {
	//NSArray *sectionTitles;
	//key: section title value: session object 
	//NSDictionary *sessionData;
	id <SessionDetailProtocol> detailViewController;
	SessionListType listType;
	NSDate *startDate;
	NSDate *endDate;
	NSString *title;
}

@end
