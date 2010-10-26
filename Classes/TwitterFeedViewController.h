//
//  TwitterFeedViewController.h
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"

@class SA_OAuthTwitterEngine;

@interface TwitterFeedViewController : UIViewController <SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, MGTwitterEngineDelegate, UITableViewDelegate, UITextViewDelegate> {
	SA_OAuthTwitterEngine *_engine;
	NSArray *statusesToDisplay;
	NSMutableDictionary *twitterImageCache;
	
	IBOutlet UIBarButtonItem *refreshButton;
	IBOutlet UITableView *statusTable;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UITextView *statusEntry;
	IBOutlet UIBarButtonItem *cancelButton;
	IBOutlet UIBarButtonItem *flexSpace;
	
	int originalStatusEntryOrigin;
	int originalStatusEntryHeight;
}

- (IBAction)refreshPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;
- (void)hideTextField;
- (void) animateTextField: (UITextView*) textField up: (BOOL) up;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) IBOutlet UITableView *statusTable;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITextView *statusEntry;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *flexSpace;


@end
