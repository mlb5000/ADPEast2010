//
//  SessionListFetchedViewController.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SessionListProtocol.h"

@protocol SessionDetailProtocol;

@interface SessionListFetchedViewController : UITableViewController <SessionListProtocol, NSFetchedResultsControllerDelegate> {

	SessionListType listType;
	NSArray *sectionTitles;
	NSDictionary *sessionData;
	id <SessionDetailProtocol> detailViewController;
	NSDate *startDate;
	NSDate *endDate;
	BOOL displayingDetail;
	NSString *title;
	
	NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context; 
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@end
