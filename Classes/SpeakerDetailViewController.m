//
//  SpeakerDetailViewController.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpeakerDetailViewController.h"


@implementation SpeakerDetailViewController

@synthesize speakers, doneButton, speakerName, speakerDescription, speakerImage, speakerCompany, scrollView;

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
	//self.scrollView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"scrollBackground.bmp"]];
	id <SpeakerProtocol> speaker = [[speakers allObjects] objectAtIndex:0];
	speakerName.text = speaker.name;
	speakerDescription.text = speaker.blurb;
	speakerCompany.text = speaker.company;
	UIImage *image = [[UIImage alloc] initWithData:speaker.image];
	speakerImage.image = image;
	[image release];
	
	CGSize maximumLabelSize = CGSizeMake(296,9999);	
	CGSize expectedLabelSize = [speaker.blurb sizeWithFont:speakerDescription.font 
										 constrainedToSize:maximumLabelSize 
											 lineBreakMode:speakerDescription.lineBreakMode]; 
	
	[scrollView setContentSize:CGSizeMake(speakerDescription.frame.size.width, speakerDescription.frame.origin.y + expectedLabelSize.height + 50)];
	
	//adjust the label the the new height.
	CGRect newFrame = speakerDescription.frame;
	newFrame.size.height = expectedLabelSize.height+40;
	speakerDescription.frame = newFrame;
	speakerDescription.text = speaker.blurb;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)donePressed:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
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
	[doneButton release];
	[speakers release];
	[speakerImage release];
	[speakerName release];
	[speakerCompany release];
	[speakerDescription release];
	[scrollView release];
	
    [super dealloc];
}


@end
