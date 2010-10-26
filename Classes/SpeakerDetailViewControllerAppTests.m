//
//  SpeakerDetailViewControllerAppTests.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpeakerDetailViewControllerAppTests.h"
#import "SpeakerDetailViewController.h"

@implementation SpeakerDetailViewControllerAppTests


- (void) setUp {
	controller = [[SpeakerDetailViewController alloc] initWithNibName:@"SpeakerDetailViewController" bundle:nil];
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
	STAssertNotNil(controller.view, nil);
	STAssertNotNil(controller.speakerImage, nil);
	STAssertNotNil(controller.speakerName, nil);
	STAssertNotNil(controller.speakerCompany, nil);
	STAssertNotNil(controller.speakerDescription, nil);
	STAssertNotNil(controller.scrollView, nil);
	STAssertNotNil(controller.doneButton, nil);
}


- (void) testUIButtonActionBinding {
	[controller loadView]; //Here we must call loadView since we have not accessed the controller's view property to trigger view loading from the nib
	STAssertTrue(controller.doneButton.action == @selector(donePressed:), nil);
}


@end
