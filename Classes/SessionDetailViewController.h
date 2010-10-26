//
//  SessionDetailViewController.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionDetailProtocol.h"

@interface SessionDetailViewController : UIViewController<SessionDetailProtocol> {
	id <SessionProtocol> session;
	NSString *title;
	IBOutlet UILabel *speakerLabelMain;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *trackNameLabel;
	IBOutlet UILabel *sessionDescription;
	IBOutlet UIButton *attendingButton;
	IBOutlet UIButton *feedbackButton;
	IBOutlet UIButton *speakerButton;
	IBOutlet UIScrollView *scrollView;
}

- (IBAction)attendingPressed:(id)sender;
- (IBAction)feedbackPressed:(id)sender;
- (IBAction)speakerDetailPressed:(id)sender;

@property (nonatomic, retain) id <SessionProtocol> session;
@property (nonatomic, retain) UILabel *speakerLabelMain;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *trackNameLabel;
@property (nonatomic, retain) UILabel *sessionDescription;
@property (nonatomic, retain) UIButton *attendingButton;
@property (nonatomic, retain) UIButton *feedbackButton;
@property (nonatomic, retain) UIButton *speakerButton;
@property (nonatomic, retain) UIScrollView *scrollView;

@end
