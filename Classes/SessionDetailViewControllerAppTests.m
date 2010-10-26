//
//  SessionDetailViewControllerAppTests.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailViewControllerAppTests.h"
#import "SessionDetailViewController.h"
#import "SessionProtocol.h"
#import "SessionMock.h"
#import "OCMock/OCMock.h"
#import "SpeakerProtocol.h"
#import "SpeakerDetailProtocol.h"


@interface SessionDetailViewControllerAppTests ()

- (void) assertThatAllOutletsAreEnabled;

@end

@implementation SessionDetailViewControllerAppTests


- (void) setUp {
	controller = [[SessionDetailViewController alloc] initWithNibName:@"SessionDetailViewController" bundle:nil];
}


- (void) tearDown {
	[controller release];
}


- (void) testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}


- (void) testViewBinding {
	[controller loadView]; //It is not strictly necessary to call loadView for this test as we access the view property which will call loadView if view is nil
	
	[self assertThatAllOutletsAreEnabled];
}

- (void) assertThatAllOutletsAreEnabled {
	STAssertNotNil(controller.view, nil);
	STAssertNotNil(controller.attendingButton, nil);
	STAssertNotNil(controller.feedbackButton, nil);
	STAssertNotNil(controller.sessionDescription, nil);
	STAssertNotNil(controller.speakerLabelMain, nil);
	STAssertNotNil(controller.trackNameLabel, nil);
	STAssertNotNil(controller.titleLabel, nil);
	STAssertNotNil(controller.attendingButton, nil);
	STAssertNotNil(controller.speakerButton, nil);
}


- (void) testattendingButton_ActionBinding_IsCorrect {
	[controller loadView]; //Here we must call loadView since we have not accessed the controller's view property to trigger view loading from the nib
	STAssertTrue([[controller.attendingButton actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside] containsObject:@"attendingPressed:"], nil);
}


- (void) testfeedbackButton_ActionBinding_IsCorrect {
	[controller loadView]; //Here we must call loadView since we have not accessed the controller's view property to trigger view loading from the nib
	STAssertTrue([[controller.feedbackButton actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside] containsObject:@"feedbackPressed:"], nil);
}


- (void) testspeakerButton_ActionBinding_IsCorrect {
	[controller loadView]; //Here we must call loadView since we have not accessed the controller's view property to trigger view loading from the nib
	STAssertTrue([[controller.speakerButton actionsForTarget:controller forControlEvent:UIControlEventTouchUpInside] containsObject:@"speakerDetailPressed:"], nil);
}


- (void) testPressingAttendingButton_ChangesStateOfSessionAndButton {
	SessionMock *mockSession = [[SessionMock alloc] init];
	mockSession.attending = [NSNumber numberWithBool:NO];
	
	UIButton *attendingButton = [[UIButton alloc] init];
	id mockButton = [OCMockObject partialMockForObject:attendingButton];
	
	controller.session = mockSession;
	controller.attendingButton = mockButton;
	
	[[mockButton expect] setTitle:@"I won't be there" forState: UIControlStateNormal];
	[[mockButton expect] setTitle:@"I won't be there" forState: UIControlStateApplication];
	[[mockButton expect] setTitle:@"I won't be there" forState: UIControlStateHighlighted];
	[[mockButton expect] setTitle:@"I won't be there" forState: UIControlStateReserved];
	[[mockButton expect] setTitle:@"I won't be there" forState: UIControlStateSelected];
	[[mockButton expect] setTitle:@"I won't be there" forState: UIControlStateDisabled];	
	[controller attendingPressed:nil];
	STAssertEquals([NSNumber numberWithBool:YES], mockSession.attending, nil);
	[mockButton verify];
	
	[[mockButton expect] setTitle:@"I'll be there!" forState: UIControlStateNormal];
	[[mockButton expect] setTitle:@"I'll be there!" forState: UIControlStateApplication];
	[[mockButton expect] setTitle:@"I'll be there!" forState: UIControlStateHighlighted];
	[[mockButton expect] setTitle:@"I'll be there!" forState: UIControlStateReserved];
	[[mockButton expect] setTitle:@"I'll be there!" forState: UIControlStateSelected];
	[[mockButton expect] setTitle:@"I'll be there!" forState: UIControlStateDisabled];
	[controller attendingPressed:nil];	 
	STAssertEquals([NSNumber numberWithBool:NO], mockSession.attending, nil);
	[mockButton verify];
}


- (void) testViewUnloading {
	[controller loadView];
	[self assertThatAllOutletsAreEnabled];
	[controller didReceiveMemoryWarning];
	//STAssertNil(controller.attendingButton, nil); //Note that while viewController.view is nil here we cannot test that directly as accessing view will trigger a call to loadView. Instead we can only test that our outlets have been released as expected.
	[controller loadView];
	[self assertThatAllOutletsAreEnabled];
}


- (void) testpressingSpeakerButtonPushesModalDetailView {
	id<SpeakerDetailProtocol> speakerDetail = [OCMockObject niceMockForProtocol:@protocol(SpeakerDetailProtocol)];
	id mockSessionDetail = [OCMockObject partialMockForObject:controller];
	
	SessionMock *mockSession = [[SessionMock alloc] init];
	
	controller.session = mockSession;
	controller.speakerDetailController = speakerDetail;
	[[((OCMockObject*)speakerDetail) expect] setSpeakers:mockSession.speakers];
	
	[controller loadView];
	[[mockSessionDetail expect] presentModalViewController:speakerDetail animated:YES];
	
	[controller speakerDetailPressed:nil];
	[((OCMockObject*)speakerDetail) verify];
	[mockSessionDetail verify];
}


@end
