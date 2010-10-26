//
//  ScheduleViewControllerUnitTests.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewControllerUnitTests.h"
#import "ScheduleViewController.h"
#import "UIKit/UIKit.h"
#import "OCMock/OCMock.h"

@implementation ScheduleViewControllerUnitTests

- (void) setUp {
	controller = [[[ScheduleViewController alloc] init] autorelease];
	tableViewMock = [OCMockObject niceMockForClass:[UITableView class]];
}

- (void) testnumberOfSectionsInTableView_EqualsTwo {
	STAssertEquals([controller numberOfSectionsInTableView:tableViewMock], 2, nil);
}

- (void) testnumberOfRowsInSection_SectionZero_EqualsTwo {
	STAssertEquals([controller tableView:tableViewMock numberOfRowsInSection:0], 2, nil);
}

- (void) testnumberOfRowsInSection_SectionOne_EqualsSix {
	STAssertEquals([controller tableView:tableViewMock numberOfRowsInSection:1], 6, nil);
}

- (void) testnumberOfRowsInSection_UnknownSection_EqualsZero {
	STAssertEquals([controller tableView:tableViewMock numberOfRowsInSection:2], 0, nil);
}

- (void) testtitleForHeaderInSection_IsAlwaysSpace {
	STAssertTrue([[controller tableView:tableViewMock titleForHeaderInSection:0] isEqualToString:@" "], nil);
	STAssertTrue([[controller tableView:tableViewMock titleForHeaderInSection:1] isEqualToString:@" "], nil);
	STAssertTrue([[controller tableView:tableViewMock titleForHeaderInSection:2] isEqualToString:@" "], nil);
}

@end
