//
//  SessionListViewController.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionListViewController.h"
#import "SessionCollection.h"
#import "SessionProtocol.h"
#import "TrackProtocol.h"
#import "SpeakerProtocol.h"
#import "SessionDetailProtocol.h"
#import "SpeakerDetailViewController.h"

@interface SessionListViewController()

- (NSString *)getTimeRangeString:(NSDate *)startTime endTime:(NSDate *)endTime;

@end

@implementation SessionListViewController

@synthesize sessionData, sectionTitles, detailViewController, listType,startDate, endDate, title;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.navigationItem.title = title;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sectionTitles.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray*)[sessionData objectForKey:[sectionTitles objectAtIndex:section]]).count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionTitles objectAtIndex:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"SessionCell";
    static NSInteger TitleTag = 1;
	static NSInteger TrackTag = 2;
	static NSInteger SpeakerTag = 3;
	static NSInteger TimeTag = 4;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		CGRect frame;
		frame.origin.x = 10;
		frame.origin.y = 5;
		frame.size.height = 30;
		frame.size.width = 280;		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
		UIFont *titleFont = [UIFont fontWithName:@"Verdana-Bold" size:12];
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel.numberOfLines = 2;
		titleLabel.font = titleFont;
		titleLabel.tag = TitleTag;		
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
		
		frame.origin.x = 10;
		frame.origin.y = 45;
		frame.size.height = 25;
		frame.size.width = 150;
		UILabel *trackLabel = [[UILabel alloc] initWithFrame:frame];
		UIFont *trackFont = [UIFont fontWithName:@"Verdana-Bold" size:10];
		trackLabel.textColor = [UIColor grayColor];
		trackLabel.backgroundColor = [UIColor clearColor];
		trackLabel.font = trackFont;
		trackLabel.tag = TrackTag;
		[cell.contentView addSubview:trackLabel];
		[trackLabel release];
		
		frame.origin.x = 10;
		frame.origin.y = 32;
		frame.size.height = 25;
		frame.size.width = 150;
		UILabel *timeLabel = [[UILabel alloc] initWithFrame:frame];
		UIFont *timeFont = [UIFont fontWithName:@"Verdana-Bold" size:10];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.font = timeFont;
		timeLabel.tag = TimeTag;
		[cell.contentView addSubview:timeLabel];
		[timeLabel release];
		
		frame.origin.x = 160;
		frame.origin.y = 45;
		frame.size.height = 25;
		frame.size.width = 150;
		UILabel *speakerLabel = [[UILabel alloc] initWithFrame:frame];
		UIFont *speakerFont = [UIFont fontWithName:@"Verdana-Bold" size:10];
		speakerLabel.backgroundColor = [UIColor clearColor];
		speakerLabel.font = speakerFont;
		speakerLabel.textAlignment = UITextAlignmentRight;
		speakerLabel.tag = SpeakerTag;
		[cell.contentView addSubview:speakerLabel];
		[speakerLabel release];
	}
	
	UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:TitleTag];
	UILabel *trackLabel = (UILabel *)[cell.contentView viewWithTag:TrackTag];
	UILabel *speakerLabel = (UILabel *)[cell.contentView viewWithTag:SpeakerTag];
	UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:TimeTag];
	
	NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
	SessionCollection *sessionsForTime = [sessionData objectForKey:sectionTitle];
	id <SessionProtocol> session = [sessionsForTime getSessionAt:indexPath.row];
	
	titleLabel.text = session.title;
	trackLabel.text = ((id <TrackProtocol>)session.track).name;
	if (listType == MultiDay) {
		timeLabel.text = [self getTimeRangeString:session.startTime endTime:session.endTime];
	}
	else {
		timeLabel.text = @"";
	}

	NSArray *speakers = [session.speakers allObjects];

	if ([speakers count] > 0) {
		speakerLabel.text = ((id <SpeakerProtocol>)[speakers objectAtIndex:0]).name;
	}
	else {
		speakerLabel.text = @"";
	}

	
    return cell;
}


- (NSString *)getTimeRangeString:(NSDate *)startTime endTime:(NSDate *)endTime {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"h:mm a";
	
	NSString *timeRange = [NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:startTime], [formatter stringFromDate:endTime]];
	return timeRange;
}


- (void)scrollToTop {
	if ([sessionData allKeys].count == 0) {
		return;
	}
	
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


- (void)refreshData {
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id <SessionProtocol> session = [[sessionData objectForKey:[sectionTitles objectAtIndex:indexPath.section]] getSessionAt:indexPath.row];
	
	detailViewController.session = session;
	detailViewController.speakerDetailController = [[SpeakerDetailViewController alloc] initWithNibName:@"SpeakerDetailViewController" bundle:nil];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[sessionData release];
	[sectionTitles release];
	[detailViewController release];
	[startDate release];
	[endDate release];
	[title release];
	
    [super dealloc];
}


@end

