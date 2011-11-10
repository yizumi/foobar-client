//
//  HistoryViewController.m
//  foobar
//
//  Created by 泉 雄介 on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "TransactionInfo.h"

@implementation HistoryViewController

@synthesize fetchedResults;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        canLoadMore = NO;
    }
    return self;
}

- (void)dealloc
{
    [fetchedResults release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Retrieve the items from the local persistence
    self.fetchedResults = [[TransactionInfoService sharedInstance] fetchAll];
    
    // Also initialize the load for the most recent history items
    [[TransactionInfoService sharedInstance] synchronizeData:page withDelegate:self];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"Returning number of sections: %d", [[self.fetchedResults sections] count]);
    return [[self.fetchedResults sections] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = [[[self.fetchedResults sections] objectAtIndex:section] name];
    NSLog(@"Returning Title: %@", title);
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResults sections] objectAtIndex:section];
    int val = [sectionInfo numberOfObjects];
    
    // Is this the last section?
    if ([[self.fetchedResults sections] count] -1 == section)
    {
        // Do we want to show "Load More"?
        NSLog(@"Can Load More:%@", canLoadMore ? @"YES" : @"NO");
        if (canLoadMore == YES)
        {
            // give it a space for "Load More"
            val++;
        }
    }
    return val;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Is this the last section?
    if (indexPath.section == [[self.fetchedResults sections] count] -1)
    {
        id<NSFetchedResultsSectionInfo> info = [[self.fetchedResults sections] objectAtIndex:indexPath.section];
        if (indexPath.row == [info numberOfObjects])
        {
            cell.textLabel.text = @"Load More";
            return cell;
        }
    }
    // Configure the cell...
    TransactionInfo* hist = (TransactionInfo*)[self.fetchedResults objectAtIndexPath:indexPath];
    cell.textLabel.text = hist.shopName;   
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == [[self.fetchedResults sections] count] -1)
    {
        id<NSFetchedResultsSectionInfo> info = [[self.fetchedResults sections] objectAtIndex:indexPath.section];
        if (indexPath.row == [info numberOfObjects])
        {
            [[TransactionInfoService sharedInstance] synchronizeData:page withDelegate:self];
            return;
        }
    }
    
}

// ================================ TransactionInfoServiceDelegate ================================
- (void) service:(TransactionInfoService*)service onSuccess:(BOOL)success hasMore:(BOOL)hasMore
{
    // Redraw stuff here.
    self.fetchedResults = [service fetchAll];
    NSLog(@"Has more:%@", hasMore ? @"YES" : @"NO");
    canLoadMore = hasMore;
    UITableView* t = (UITableView*)self.view;
    [t reloadData];
    [t setNeedsDisplay];
    page++;
}

@end
