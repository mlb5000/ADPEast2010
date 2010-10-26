//
//  SessionDetailViewController.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "SessionProtocol.h"
#import "SpeakerProtocol.h"
#import "TrackProtocol.h"
#import "SpeakerDetailProtocol.h"
#import "AgileDevPracticesEast2010AppDelegate.h"

@interface SessionDetailViewController ()

- (void)setAttendingButtonText;

@end

@implementation SessionDetailViewController

@synthesize session;
@synthesize speakerDetailController;
@synthesize speakerLabelMain;
@synthesize titleLabel;
@synthesize trackNameLabel;
@synthesize sessionDescription;
@synthesize attendingButton;
@synthesize feedbackButton;
@synthesize speakerButton;
@synthesize scrollView;
@synthesize title;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated {
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"scrollBackground.bmp"]];
	
	if ([[session.speakers allObjects] count] > 0) {
		id <SpeakerProtocol> speaker = [[session.speakers allObjects] objectAtIndex:0];
		speakerLabelMain.text = speaker.name;
		speakerLabelMain.hidden = NO;
		speakerButton.hidden = NO;
	}
	else {
		speakerLabelMain.hidden = YES;
		speakerButton.hidden = YES;
	}

	self.navigationItem.title = title;
	titleLabel.text = session.title;
	trackNameLabel.text = session.track.name;
	
	CGSize maximumLabelSize = CGSizeMake(296,9999);
	
	CGSize expectedLabelSize = [session.blurb sizeWithFont:sessionDescription.font 
												  constrainedToSize:maximumLabelSize 
													  lineBreakMode:sessionDescription.lineBreakMode]; 
	
	[scrollView setContentSize:CGSizeMake(sessionDescription.frame.size.width, sessionDescription.frame.origin.y + expectedLabelSize.height + 50)];
	
	//adjust the label the the new height.
	CGRect newFrame = sessionDescription.frame;
	newFrame.size.height = expectedLabelSize.height+40;
	sessionDescription.frame = newFrame;
	sessionDescription.text = session.blurb;
	[self setAttendingButtonText];
}

- (void)setAttendingButtonText {
	NSString *title = nil;
	if ([session.attending boolValue] == YES) {
		title = @"I won't be there";
	}
	else {
		title = @"I'll be there!";
	}
	
	[self.attendingButton setTitle: title forState: UIControlStateNormal];
	[self.attendingButton setTitle: title forState: UIControlStateApplication];
	[self.attendingButton setTitle: title forState: UIControlStateHighlighted];
	[self.attendingButton setTitle: title forState: UIControlStateReserved];
	[self.attendingButton setTitle: title forState: UIControlStateSelected];
	[self.attendingButton setTitle: title forState: UIControlStateDisabled];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (IBAction)attendingPressed:(id)sender {
	session.attending = [NSNumber numberWithBool:([session.attending boolValue] ^ 1)];
	[self setAttendingButtonText];
	//NSError *error;
	//[[(AgileDevPracticesEast2010AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] save:&error];
}


- (IBAction)feedbackPressed:(id)sender {
}


- (IBAction)speakerDetailPressed:(id)sender {
	speakerDetailController.speakers = session.speakers;
	[self presentModalViewController:speakerDetailController animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[session release];
	[speakerLabelMain release];
	[titleLabel release];
	[trackNameLabel release];
	[sessionDescription release];
	[attendingButton release];
	[feedbackButton release];
	[speakerButton release];
	[scrollView release];
	[speakerDetailController release];
	
    [super dealloc];
}


@end
