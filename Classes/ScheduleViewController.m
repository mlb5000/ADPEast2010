//
//  ScheduleViewController.m
//  AgileDevPracticesEast2010
//
//  Created by Matt Baker on 9/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SessionCollection.h"
#import "SessionListViewController.h"
#import "SessionDetailViewController.h"
#import "SessionListProtocol.h"

@interface ScheduleViewController ()

- (NSString*) getDayOfWeekTitle:(NSInteger)dayOfWeek;
- (NSDictionary*) getSessionTimeDictionaryFrom:(SessionCollection*)sessionList;
- (NSDictionary*) getSessionDayDictionaryFrom:(SessionCollection*)sessionList;

@end


@implementation ScheduleViewController

@synthesize sessions, listViewController;

- (void)dealloc {
	self.listViewController = nil;
	self.sessions = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollBackground.bmp"]]; 
	self.tableView.backgroundColor = [UIColor clearColor];
	
	//self.listViewController = nil;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return 3;
	}
	else if (section == 1){
		return 6;
	}

    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSString *text = nil;
    
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			text = @"My Schedule";
		}
		else if (indexPath.row == 1) {
			text = @"Popular Sessions";
		}
		else if (indexPath.row == 2) {
			text = @"All Sessions";
		}
	}
	else if (indexPath.section == 1) {
		text = [self getDayOfWeekTitle:indexPath.row];
	}
	
	cell.textLabel.text = text;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)getDayOfWeekTitle:(NSInteger)dayOfWeek {
	return [[NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", nil] objectAtIndex:dayOfWeek];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @" ";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	CGRect frame;
	frame.size.height = 5;
	frame.size.width = tableView.frame.size.width;
	frame.origin.x = 0;
	frame.origin.y = 0;
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	CGRect frame;
	frame.size.height = 0;
	frame.size.width = tableView.frame.size.width;
	frame.origin.x = 0;
	frame.origin.y = 0;
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.0;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {		
	NSArray *array = [NSArray arrayWithObjects:@"2010-11-14",@"2010-11-15",@"2010-11-16",@"2010-11-17",@"2010-11-18",@"2010-11-19",@"2010-11-20",nil];
	
	/*SessionCollection *sessionsToDisplay = nil;*/
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"yyyy-MM-dd";
	
	if (indexPath.section == 1) {		
		NSDate *day = [formatter dateFromString:[array objectAtIndex:indexPath.row]];
		formatter.dateFormat = @"ccc MMM d, yyyy";
		NSString *dayString = [formatter stringFromDate:day];
		
		SessionCollection *sessionsToDisplay = [sessions getSessionsOnDay:day];
		listViewController.listType = SingleDay;
		listViewController.title = dayString;
		listViewController.sectionTitles = [sessionsToDisplay getStartTimeStrings];
		listViewController.sessionData = [self getSessionTimeDictionaryFrom:sessionsToDisplay];
		
		if (listViewController.detailViewController == nil) {
			listViewController.detailViewController = [[SessionDetailViewController alloc] initWithNibName:@"SessionDetailViewController" bundle:nil];
		}
		
		[self.navigationController pushViewController:listViewController animated:YES];
		[listViewController scrollToTop];
		[listViewController refreshData];
		
		/*if (indexPath.row == 1 || indexPath.row == 2) {
			NSDate *beginDay = [formatter dateFromString:[array objectAtIndex:indexPath.row]];
			NSDate *endDay = [formatter dateFromString:[array objectAtIndex:indexPath.row+1]];
		
			listViewController.startDate = beginDay;
			listViewController.endDate = endDay;
		}
		listViewController.listType = SingleDay;*/
	}
	else {
		if (indexPath.row == 0)
		{
			SessionCollection *sessionsToDisplay = [sessions getSessionsUserIsAttending];
			listViewController.listType = MultiDay;
			listViewController.title = @"My Sessions";
			listViewController.sectionTitles = [sessionsToDisplay getDayStartTimeStrings]; 
			listViewController.sessionData = [self getSessionDayDictionaryFrom:sessionsToDisplay];
		}
		else
		{
			listViewController.title = @"All Sessions";
			listViewController.listType = MultiDay;
			listViewController.sectionTitles = [sessions getDayStartTimeStrings];
			listViewController.sessionData = [self getSessionDayDictionaryFrom:sessions];
		}
		
		if (listViewController.detailViewController == nil) {
			listViewController.detailViewController = [[SessionDetailViewController alloc] initWithNibName:@"SessionDetailViewController" bundle:nil];
		}
		
		[self.navigationController pushViewController:listViewController animated:YES];
		[listViewController scrollToTop];
		[listViewController refreshData];
		
		/*NSDate *beginDay = [formatter dateFromString:[array objectAtIndex:0]];
		NSDate *endDay = [formatter dateFromString:[array objectAtIndex:array.count-1]];
		
		listViewController.startDate = beginDay;
		listViewController.endDate = endDay;
		if (indexPath.row == 0) {
			listViewController.listType = Attending;
		}
		else {
			listViewController.listType = MultiDay;
		}*/
	}
}


- (NSDictionary*) getSessionTimeDictionaryFrom:(SessionCollection*)sessionList {
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	
	NSArray *timeStrings = [sessionList getStartTimeStrings];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"h:mm a";
	
	for (unsigned int i = 0; i < timeStrings.count; i++) {
		NSDate *time = [formatter dateFromString:[timeStrings objectAtIndex:i]];
		[dict setObject:[sessionList getSessionsAtTime:time] forKey:[timeStrings objectAtIndex:i]];
	}
	
	[formatter release];
	return dict;
}


- (NSDictionary*) getSessionDayDictionaryFrom:(SessionCollection*)sessionList {
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	
	NSArray *dayStrings = [sessionList getDayStartTimeStrings];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"ccc MMM d, yyyy";
	
	for (unsigned int i = 0; i < dayStrings.count; i++) {
		NSDate *day = [formatter dateFromString:[dayStrings objectAtIndex:i]];
		[dict setObject:[sessionList getSessionsOnDay:day] forKey:[dayStrings objectAtIndex:i]];
	}
	
	return dict;
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


@end

