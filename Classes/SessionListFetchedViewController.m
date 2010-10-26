//
//  SessionListFetchedViewController.m
//  AgileDevPracticesEast2010
//
//  Created by Matthew Baker on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionListFetchedViewController.h"
#import "SessionProtocol.h"
#import "TrackProtocol.h"
#import "SpeakerProtocol.h"
#import "AgileDevPracticesEast2010AppDelegate.h"
#import "SpeakerDetailViewController.h"

const static NSInteger TitleTag = 1;
const static NSInteger TrackTag = 2;
const static NSInteger SpeakerTag = 3;
const static NSInteger TimeTag = 4;

@interface SessionListFetchedViewController ()

- (NSString *)getTimeRangeString:(NSDate *)startTime endTime:(NSDate *)endTime;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation SessionListFetchedViewController

@synthesize listType, sectionTitles, sessionData, detailViewController, startDate, endDate, context, title;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)dealloc {
	self.fetchedResultsController = nil;
	self.sectionTitles = nil;
	self.sessionData = nil;
	self.detailViewController = nil;
	self.startDate = nil;
	self.endDate = nil;
	self.context = nil;
	self.title = nil;
	
	[super dealloc];
}


- (NSFetchedResultsController *)fetchedResultsController {
	
    if (_fetchedResultsController != nil) {
		NSLog(@"Controller is already populated");
        return _fetchedResultsController;
    }
	
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Session" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
	
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
							  initWithKey:@"startTime" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
	[sort release];
	
	NSString *predicateString = nil;
	NSString *sectionKey = nil;
	if (listType == MultiDay) {
		sectionKey = @"dayString";
		predicateString = @"(startTime between {%@,%@}) OR (endTime between {%@,%@})";
	}
	else if (listType == SingleDay) {
		sectionKey = @"startTimeString";
		predicateString = @"(startTime between {%@,%@}) OR (endTime between {%@,%@})";
	}
	else {
		sectionKey = @"dayString";
		predicateString = @"attending == true";
	}

	[NSFetchedResultsController deleteCacheWithName:nil];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString, startDate, endDate, startDate, endDate];
	[fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:20];

    NSFetchedResultsController *theFetchedResultsController = 
	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
										managedObjectContext:_context sectionNameKeyPath:sectionKey
												   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
	
    [fetchRequest release];
    [theFetchedResultsController release];
	
    return _fetchedResultsController;    
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	_context = [(AgileDevPracticesEast2010AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		
	displayingDetail = NO;
    //self.title = @"Sessions";
}


- (void)viewWillAppear:(BOOL)animated {		
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	[super viewWillAppear:animated];
	//[self.tableView clearsContextBeforeDrawing];
	//[self.tableView reloadData];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	NSLog(@"View will disappear");
	if (!displayingDetail) {
		NSLog(@"releasing fetchedResultsController");
		[NSFetchedResultsController deleteCacheWithName:nil];
		self.fetchedResultsController = nil;
		self.context = nil;
	}
	displayingDetail = NO;
}

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
    return [self.fetchedResultsController sections].count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	
    return [sectionInfo numberOfObjects];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	
	return sectionInfo.name;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"SessionCell";
    
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
		
		frame.origin.x = 200;
		frame.origin.y = 45;
		frame.size.height = 25;
		frame.size.width = 150;
		UILabel *speakerLabel = [[UILabel alloc] initWithFrame:frame];
		UIFont *speakerFont = [UIFont fontWithName:@"Verdana-Bold" size:10];
		speakerLabel.backgroundColor = [UIColor clearColor];
		speakerLabel.font = speakerFont;
		speakerLabel.tag = SpeakerTag;
		[cell.contentView addSubview:speakerLabel];
		[speakerLabel release];
	}
	
	[self configureCell:cell atIndexPath:indexPath];	
	
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:TitleTag];
	UILabel *trackLabel = (UILabel *)[cell.contentView viewWithTag:TrackTag];
	UILabel *speakerLabel = (UILabel *)[cell.contentView viewWithTag:SpeakerTag];
	UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:TimeTag];
	
	id <SessionProtocol> session = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
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
}


- (NSString *)getTimeRangeString:(NSDate *)startTime endTime:(NSDate *)endTime {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"h:mm a";
	
	NSString *timeRange = [NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:startTime], [formatter stringFromDate:endTime]];
	return timeRange;
}


- (void)scrollToTop {	
	[self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}


- (void)refreshData {
	//[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id <SessionProtocol> session = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	detailViewController.session = session;
	detailViewController.speakerDetailController = [[SpeakerDetailViewController alloc] initWithNibName:@"SpeakerDetailViewController" bundle:nil];
	
	displayingDetail = YES;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -
#pragma mark NSFetchedResultsController Delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


/*- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	NSLog(@"Changed object");
    UITableView *tableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
			NSLog(@"Object deleted: %@", indexPath);
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}*/

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate: {
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
        }
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
	[self.tableView reloadData];
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
	NSLog(@"View did unload");
	//self.fetchedResultsController = nil;
}


@end

