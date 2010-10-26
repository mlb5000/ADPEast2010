//
//  TwitterFeedViewController.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import <QuartzCore/QuartzCore.h>

#define kOAuthConsumerKey				@"54D6CrHktx2F4zgljj7w"
#define kOAuthConsumerSecret			@"QnugJxCG0xmxmxhah8RKZJIDnoDsTR3LAFd8AvTBI"
#define QUERY_VALUE						@"#agile"
#define LOADINGVIEW_TAG					12

@interface TwitterFeedViewController ()

- (void) updateTableData;
- (UIImage *)getUIImage:(NSString*)url;
- (void)configureToolbar:(BOOL)keyboardShowing;
- (void)showLoadingScreen;
- (void)hideLoadingScreen;

@end


@implementation TwitterFeedViewController

@synthesize refreshButton, statusTable, toolbar, statusEntry, cancelButton, flexSpace;

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
	[self updateTableData];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}


- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}


- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier {
	[searchResults retain];
	statusesToDisplay = searchResults;
	[statusTable reloadData];
	[self hideLoadingScreen];
}


//=============================================================================================================================
#pragma mark ViewController Stuff


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		 twitterImageCache = [[NSMutableDictionary alloc] init];
		 _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
		 _engine.consumerKey = kOAuthConsumerKey;
		 _engine.consumerSecret = kOAuthConsumerSecret;
	 }
	 
	 return self;
 }
 

- (void) viewWillAppear:(BOOL)animated {
	[self configureToolbar:NO];
	statusEntry.layer.borderWidth = 5.0f;
	statusEntry.layer.borderColor = [UIColor grayColor].CGColor;
	originalStatusEntryHeight = statusEntry.frame.size.height;
	originalStatusEntryOrigin = statusEntry.frame.origin.y;
	statusEntry.text = QUERY_VALUE;
}

- (void) viewDidAppear: (BOOL)animated {	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
		[self updateTableData];
	}
}

- (void) showLoadingScreen {
	UIActivityIndicatorView *loadingView = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	loadingView.frame = CGRectMake(145, 160, 25, 25);
	loadingView.tag = LOADINGVIEW_TAG;
	[self.view addSubview:loadingView];
	[loadingView startAnimating];
}

- (void) hideLoadingScreen {
	UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:LOADINGVIEW_TAG];
	[tmpimg removeFromSuperview];
}


- (void) updateTableData {
	[_engine getSearchResultsForQuery:QUERY_VALUE sinceID:0 startingAtPage:0 count:40];
	[self showLoadingScreen];
}

- (IBAction)refreshPressed:(id)sender {
	[self updateTableData];
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)cancelPressed:(id)sender {
	[self hideTextField];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (![text isEqualToString:@"\n"]) {
		return YES;
	}
	if (textView.text.length == 179) {
		return NO;
	}
	
	NSLog(@"Test submission: %@", statusEntry.text);
	//[_engine sendUpdate:statusEntry.text];
	[self hideTextField];
	statusEntry.text = QUERY_VALUE;
	return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self animateTextField: textView up: YES];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextField: textView up: NO];
}


- (void)hideTextField
{
	[statusEntry resignFirstResponder];
}


- (void) animateTextField: (UITextView*) textField up: (BOOL) up
{
    const int movementDistance = 165; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
	const int upOrigin = 204;
	const int downOrigin = originalStatusEntryOrigin;
	const int upHeight = 205;
	const int downHeight = originalStatusEntryHeight;
	
    int movement = (up ? -movementDistance : movementDistance);
	
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
	CGRect frame = self.statusEntry.frame;
	frame.origin.y = (up ? upOrigin : downOrigin);
	frame.size.height = (up ? upHeight : downHeight);
	self.statusEntry.frame = frame;
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	self.toolbar.frame = CGRectOffset(self.toolbar.frame, 0, -movement);
	self.statusTable.hidden = up;
	
	[self configureToolbar:up];
	
    [UIView commitAnimations];
}

- (void)configureToolbar:(BOOL)keyboardShowing {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
	if (keyboardShowing) {
		[array addObject:self.flexSpace];
		[array addObject:self.cancelButton];
	}
	else {
		[array addObject:self.flexSpace];
		[array addObject:self.refreshButton];
	}
	[self.toolbar setItems:array animated:YES];
	[array release];
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [statusesToDisplay count]-1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//prepopulate all the images for better UX
	if ([twitterImageCache allKeys].count == 0) {
		for (unsigned int i = 0; i < statusesToDisplay.count-1; i++) {
			[self getUIImage:[[statusesToDisplay objectAtIndex:i] objectForKey:@"profile_image_url"]];
		}
	}
	
    static NSString *CellIdentifier = @"Cell";
    static NSInteger StatusTag = 1;
	static NSInteger ImageTag = 2;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 10;
		frame.size.height = 50;
		frame.size.width = 50;			
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.tag = ImageTag;
		[cell.contentView addSubview:imageView];
		[imageView release];
			
		UITextView *statusLabel = [[UITextView alloc] init];
		statusLabel.dataDetectorTypes = UIDataDetectorTypeAll;
		statusLabel.editable = NO;
		statusLabel.scrollEnabled = NO;
		//statusLabel.layer.borderWidth = 1.0f;
		//statusLabel.layer.borderColor = [UIColor grayColor].CGColor;
		UIFont *statusFont = [UIFont fontWithName:@"Verdana-Bold" size:10];
		statusLabel.font = statusFont;
		statusLabel.tag = StatusTag;		
		statusLabel.contentInset = UIEdgeInsetsMake(-4,-4,0,0);
		[cell.contentView addSubview:statusLabel];
		[statusLabel release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	UITextView *statusLabel = (UITextView *)[cell.contentView viewWithTag:StatusTag];
	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:ImageTag];
	
	NSDictionary *currentItem = [statusesToDisplay objectAtIndex:indexPath.row];
	NSLog(@"Current item[%d]: %@", indexPath.row, currentItem);
    NSString *value = [NSString stringWithFormat:@"%@", [currentItem objectForKey:@"text"]];
	CGSize maximumLabelSize = CGSizeMake(220,9999);
	CGSize expectedLabelSize = [value sizeWithFont:[UIFont fontWithName:@"Verdana-Bold" size:10]
								 constrainedToSize:maximumLabelSize 
									 lineBreakMode:UILineBreakModeWordWrap];
	CGRect frame = statusLabel.frame;
	frame.origin.x = 70;
	frame.origin.y = 0;
	frame.size.height = expectedLabelSize.height+20;
	frame.size.width = 220;
	statusLabel.frame = frame;
	statusLabel.text = value;
	NSString *profile_image_url = [currentItem objectForKey:@"profile_image_url"];
	imageView.image = [self getUIImage:profile_image_url];
	
    return cell;
}

- (UIImage *)getUIImage:(NSString*)url {
	if (url == nil) {
		return nil;
	}
	
	UIImage *img = [twitterImageCache objectForKey:url];
	if (img != nil) {
		return img;
	}
	
	img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
	[twitterImageCache setObject:img forKey:url];
	
	return img;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *value = [[statusesToDisplay objectAtIndex:indexPath.row] objectForKey:@"text"];

	CGSize maximumLabelSize = CGSizeMake(220,9999);
	CGSize expectedLabelSize = [value sizeWithFont:[UIFont fontWithName:@"Verdana-Bold" size:10]
										 constrainedToSize:maximumLabelSize 
											 lineBreakMode:UILineBreakModeWordWrap]; 
	
	if (expectedLabelSize.height+20 > 70) {
		return expectedLabelSize.height+20;
	}

	return 70;
}


#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	[twitterImageCache removeAllObjects];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.refreshButton = nil;
	self.toolbar = nil;
	self.statusTable = nil;
	self.statusEntry = nil;
}


- (void)dealloc {
	[_engine release];
	[statusesToDisplay release];
	[refreshButton release];
	[statusTable release];
	[twitterImageCache release];
	[toolbar release];
	[statusEntry release];
	[cancelButton release];
	[flexSpace release];
    [super dealloc];
}


@end

