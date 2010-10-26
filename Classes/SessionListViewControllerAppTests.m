//
//  SessionListViewControllerAppTests.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionListViewControllerAppTests.h"
#import "SessionListViewController.h"
#import "SessionDetailViewController.h"
#import "SessionCollection.h"
#import "SessionProtocol.h"
#import "SpeakerProtocol.h"
#import "TrackProtocol.h"
#import "OCMock/OCMock.h"

@interface SessionListViewControllerAppTests ()

- (void) fillControllerWithSessions;
- (void) addOCMockSessionWithTitle:(NSString*)title startTimeString:(NSString*)date trackNamed:(NSString*)track speakerNamed:(NSString*)speaker;
- (void) verifyRow:(NSInteger)row inSection:(NSInteger)section hasTitle:(NSString *)title trackName:(NSString *)track speakerName:(NSString *)speaker;

@end


@implementation SessionListViewControllerAppTests

- (void) setUp {
	controller = [[SessionListViewController alloc] initWithNibName:@"SessionListViewController" bundle:nil];
	sectionTitles = [[NSMutableArray alloc] init];
	sessionData = [[NSMutableDictionary alloc] init];
}


- (void) tearDown {
	[controller release];
	[sectionTitles release];
	[sessionData release];
}


- (void) testAppDelegate {    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");    
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


- (void) testDisplayOfSessions_ContainsAllFields {
	[self fillControllerWithSessions];
	
	controller.sessionData = sessionData;
	controller.sectionTitles = sectionTitles;
	
	[self verifyRow:0 inSection:0 hasTitle:@"Session 1" trackName:@"Track 1" speakerName:@"Speaker 1"];
	[self verifyRow:0 inSection:1 hasTitle:@"Session 2" trackName:@"Track 2" speakerName:@"Speaker 2"];
	[self verifyRow:1 inSection:1 hasTitle:@"Session 3" trackName:@"Track 2" speakerName:@"Speaker 1"];
}


- (void) fillControllerWithSessions {
	[self addOCMockSessionWithTitle:@"Session 1" startTimeString:@"2010-11-11 08:30:00 -0500" trackNamed:@"Track 1" speakerNamed:@"Speaker 1"];
	[self addOCMockSessionWithTitle:@"Session 2" startTimeString:@"2010-11-11 09:30:00 -0500" trackNamed:@"Track 2" speakerNamed:@"Speaker 2"];
	[self addOCMockSessionWithTitle:@"Session 3" startTimeString:@"2010-11-11 09:30:00 -0500" trackNamed:@"Track 2" speakerNamed:@"Speaker 1"];
}


- (void) verifyRow:(NSInteger)row inSection:(NSInteger)section hasTitle:(NSString *)title trackName:(NSString *)track speakerName:(NSString *)speaker {
	static NSInteger TitleTag = 1;
	static NSInteger TrackTag = 2;
	static NSInteger SpeakerTag = 3;
	
	NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
	UITableViewCell *cell = [controller tableView:controller.tableView cellForRowAtIndexPath:path];
	
	UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:TitleTag];
	UILabel *trackLabel = (UILabel *)[cell.contentView viewWithTag:TrackTag];
	UILabel *speakerLabel = (UILabel *)[cell.contentView viewWithTag:SpeakerTag];
	
	STAssertEqualObjects(titleLabel.text, title, nil);
	STAssertEqualObjects(trackLabel.text, track, nil);
	STAssertEqualObjects(speakerLabel.text, speaker, nil);
}


- (void) addOCMockSessionWithTitle:(NSString*)title startTimeString:(NSString*)date trackNamed:(NSString*)track speakerNamed:(NSString*)speaker {
	id<SessionProtocol> mock1 = [OCMockObject mockForProtocol:@protocol(SessionProtocol)];
	[[[((OCMockObject *)mock1) stub] andReturn:title] title];
	[[[((OCMockObject *)mock1) stub] andReturn:[[NSDate alloc] initWithString:date]] startTime];
	id<TrackProtocol> track1 = [OCMockObject mockForProtocol:@protocol(TrackProtocol)];
	[[[((OCMockObject *)track1) stub] andReturn:track] name];
	[[[((OCMockObject *)mock1) stub] andReturn:track1] track];
	id<SpeakerProtocol> speaker1 = [OCMockObject mockForProtocol:@protocol(SpeakerProtocol)];
	[[[((OCMockObject *)speaker1) stub] andReturn:speaker] name];
	NSSet *set = [[NSSet alloc] initWithObjects:speaker1, nil];
	[[[((OCMockObject *)mock1) stub] andReturn:set] speakers];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"h:mm a";
	NSDate *fullDate = [[NSDate alloc] initWithString:date];
	NSString *timeString = [formatter stringFromDate:fullDate];
	[fullDate release];
	[formatter release];
	
	if (![sectionTitles containsObject:timeString]) {
		[sectionTitles addObject:timeString];
	}
	
	SessionCollection *sessionsForTime = [sessionData objectForKey:timeString];
	if (sessionsForTime == nil) {
		sessionsForTime = [[SessionCollection alloc] init];
		[sessionData setObject:sessionsForTime forKey:timeString];
		[sessionsForTime release];
	}
	
	[[sessionData objectForKey:timeString] addSession:mock1];
}


- (void) testheightForRowAtIndexPath_IsSeventy {
	NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
	
	CGFloat value = [controller tableView:controller.tableView heightForRowAtIndexPath:path];
	
	CGFloat expected = 70;
	STAssertEquals(value, expected, nil);
}


- (void) testSelectingACellPushesADetailView {
	id<SessionDetailProtocol> sessionDetail = [OCMockObject niceMockForProtocol:@protocol(SessionDetailProtocol)];
	UINavigationController *navController = [[UINavigationController alloc] init];
	id navigationController = [OCMockObject partialMockForObject:navController];
	[navigationController pushViewController:controller animated:NO];
	STAssertNotNil(controller.navigationController, nil);
	
	[self fillControllerWithSessions];
	id <SessionProtocol> session = [[sessionData objectForKey:@"8:30 AM"] getSessionAt:0];
	//NSLog(@"Expected Session: %@", session);
	
	controller.sessionData = sessionData;
	controller.sectionTitles = sectionTitles;
	controller.detailViewController = sessionDetail;
	[[((OCMockObject*)sessionDetail) expect] setSession:session];
	
	[controller loadView];
	[[navigationController expect] pushViewController:sessionDetail animated:YES]; //expect that the detail view will be pushed onto the nave controller
	
	[controller tableView:controller.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[((OCMockObject*)sessionDetail) verify];
	[navigationController verify];
	
	[navController release];
}

@end
