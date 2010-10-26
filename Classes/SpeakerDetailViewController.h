//
//  SpeakerDetailViewController.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakerDetailProtocol.h"

@protocol SpeakerProtocol;

@interface SpeakerDetailViewController : UIViewController<SpeakerDetailProtocol> {
	NSSet *speakers;
	IBOutlet UIBarButtonItem  *doneButton;
	IBOutlet UIImageView *speakerImage;
	IBOutlet UILabel *speakerName;
	IBOutlet UILabel *speakerCompany;
	IBOutlet UILabel *speakerDescription;
	IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIImageView *speakerImage;
@property (nonatomic, retain) IBOutlet UILabel *speakerName;
@property (nonatomic, retain) IBOutlet UILabel *speakerCompany;
@property (nonatomic, retain) IBOutlet UILabel *speakerDescription;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)donePressed:(id)sender;

@end
