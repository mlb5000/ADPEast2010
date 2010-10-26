//
//  ScheduleViewControllerAppTests.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewControllerAppTests.h"
#import "ScheduleViewController.h"
#import "OCMock/OCMock.h"
#import "SessionListViewController.h"

@implementation ScheduleViewControllerAppTests

- (void) setUp {
	controller = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
	tableViewMock = [OCMockObject mockForClass:[UITableView class]];
}


- (void) tearDown {
	[controller release];
}


- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

- (UITableViewCell*) cellAtIndexPath:(NSInteger)section row:(NSInteger)row {
	NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
	[[[(OCMockObject *)tableViewMock stub] andReturn:nil] dequeueReusableCellWithIdentifier:@"Cell"]; 
	UITableViewCell *cell = [controller tableView:tableViewMock cellForRowAtIndexPath:path];
	
	return cell;
}

- (void) testViewBinding {
	[controller loadView]; //It is not strictly necessary to call loadView for this test as we access the view property which will call loadView if view is nil
	STAssertNotNil(controller.view, nil);
}

- (void) testViewUnloading {
	[controller loadView];
	STAssertNotNil(controller.view, nil);
	[controller didReceiveMemoryWarning];
	[controller loadView];
	STAssertNotNil(controller.view, nil);
}

- (void) testcellForRowAtIndexPath_TitleMatchExpected {
	STAssertTrue([[self cellAtIndexPath:0 row:0].textLabel.text isEqualToString:@"My Schedule"], nil);
	STAssertTrue([[self cellAtIndexPath:0 row:1].textLabel.text isEqualToString:@"Popular Sessions"], nil);
	STAssertTrue([[self cellAtIndexPath:1 row:0].textLabel.text isEqualToString:@"Sunday"], nil);
	STAssertTrue([[self cellAtIndexPath:1 row:1].textLabel.text isEqualToString:@"Monday"], nil);
	STAssertTrue([[self cellAtIndexPath:1 row:2].textLabel.text isEqualToString:@"Tuesday"], nil);
	STAssertTrue([[self cellAtIndexPath:1 row:3].textLabel.text isEqualToString:@"Wednesday"], nil);
	STAssertTrue([[self cellAtIndexPath:1 row:4].textLabel.text isEqualToString:@"Thursday"], nil);
	STAssertTrue([[self cellAtIndexPath:1 row:5].textLabel.text isEqualToString:@"Friday"], nil);
}

- (void) testcellForRowAtIndexPath_AccessoryTypeIsDisclosure {
	STAssertEquals([self cellAtIndexPath:0 row:0].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
	STAssertEquals([self cellAtIndexPath:0 row:1].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
	STAssertEquals([self cellAtIndexPath:1 row:0].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
	STAssertEquals([self cellAtIndexPath:1 row:1].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
	STAssertEquals([self cellAtIndexPath:1 row:2].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
	STAssertEquals([self cellAtIndexPath:1 row:3].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
	STAssertEquals([self cellAtIndexPath:1 row:4].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
	STAssertEquals([self cellAtIndexPath:1 row:5].accessoryType, UITableViewCellAccessoryDisclosureIndicator ,nil);
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


- (void) testSelectingACellPushesADetailView {
	id sessionListVC = [OCMockObject niceMockForClass:[SessionListViewController class]];
	UINavigationController *navController = [[UINavigationController alloc] init];
	id navigationController = [OCMockObject partialMockForObject:navController];
	[navigationController pushViewController:controller animated:NO];
	STAssertNotNil(controller.navigationController, nil);
	
	controller.listViewController = sessionListVC;
	
	[controller loadView];
	[[navigationController expect] pushViewController:sessionListVC animated:YES]; //expect that the detail view will be pushed onto the nave controller
	[[sessionListVC expect] setDetailViewController:OCMOCK_ANY];
	[controller tableView:controller.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	[sessionListVC verify];
	[navigationController verify];

	[navController release];
}

@end
