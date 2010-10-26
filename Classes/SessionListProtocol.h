//
//  SessionListProtocol.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionDetailProtocol.h"

typedef enum {
	SingleDay,
	MultiDay,
	Attending
} SessionListType;

@protocol SessionListProtocol<UITableViewDelegate, NSCoding>

@property (nonatomic) SessionListType listType;
@property (nonatomic, retain) NSArray *sectionTitles;
@property (nonatomic, retain) NSDictionary *sessionData;
@property (nonatomic, retain) id <SessionDetailProtocol> detailViewController;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSString *title;

- (void)scrollToTop;
- (void)refreshData;

@end
