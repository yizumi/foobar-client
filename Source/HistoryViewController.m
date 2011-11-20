//
//  HistoryViewController.m
//  foobar
//
//  Created by 泉 雄介 on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "TransactionInfo.h"
#import "FBConfig.h"
#import "HistoryCell.h"
#import "FBCancelTransaction.h"
#import "ShopInfoService.h"

@implementation HistoryViewController

@synthesize fetchedResults;

+ (BOOL) isShopRecord:(TransactionInfo*)tran
{
    return [[tran shopKey] longValue] == [[FBConfig sharedInstance] shopKey];
}

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
    // [[TransactionInfoService sharedInstance] synchronizeData:page withDelegate:self];  
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
    
    if ([[FBConfig sharedInstance] refreshHistory])
    {
        page = 0;
        [[FBConfig sharedInstance] setRefreshHistory:NO];
        [[TransactionInfoService sharedInstance] synchronizeData:page withDelegate:self];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

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
    static NSString *CellIdentifier = @"HistoryCell";
    
    // Is this the last section?
    if (indexPath.section == [[self.fetchedResults sections] count] -1)
    {
        id<NSFetchedResultsSectionInfo> info = [[self.fetchedResults sections] objectAtIndex:indexPath.section];
        if (indexPath.row == [info numberOfObjects])
        {
            UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:@"TableViewCell"];
                [cell autorelease];
            }
            cell.textLabel.text = NSLocalizedString(@"HistoryViewController_LoadMore",@"");
            return cell;
        }
    }

    HistoryCell* cell = (HistoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UIViewController* ctrl = [[UIViewController alloc]initWithNibName:CellIdentifier bundle:nil];
        cell = (HistoryCell*)ctrl.view;
        [ctrl release];
    }
    
    // Configure the cell...
    TransactionInfo* hist = (TransactionInfo*)[self.fetchedResults objectAtIndexPath:indexPath];
    [cell bind:hist];
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [[self.fetchedResults sections] count] -1)
    {
        id<NSFetchedResultsSectionInfo> info = [[self.fetchedResults sections] objectAtIndex:indexPath.section];
        if (indexPath.row == [info numberOfObjects])
        {
            return NO;
        }
    }
    // Return yes if it's a store's property
    TransactionInfo* tran = (TransactionInfo*)[self.fetchedResults objectAtIndexPath:indexPath];
    return [HistoryViewController isShopRecord:tran];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        TransactionInfo* tran = (TransactionInfo*)[self.fetchedResults objectAtIndexPath:indexPath];
        if ([HistoryViewController isShopRecord:tran])
        {
            FBCancelTransaction* cmd = [[[FBCancelTransaction alloc] init] autorelease];
            cmd.delegate = self;
            cmd.transactionKey = tran.key;
            [cmd execAsync];
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

// ================================ FBCommandBaseDelegate ================================
- (void)execSuccess:(id)request withResponse:(id)response
{
    if ([request class] == [FBCancelTransaction class])
    {
        NSDictionary* dict = (NSDictionary*)response;
        
        // we need to mark the item as cancelled
        NSNumber* key = (NSNumber*)[dict valueForKey:@"transactionKey"];
        [[TransactionInfoService sharedInstance] markItemAsCancelled:key];
        
        // Remove the item from the database
        self.fetchedResults = [[TransactionInfoService sharedInstance] fetchAll];
        UITableView* table = (UITableView*)self.view;
        [table reloadData];
        [table setNeedsDisplay];
        [table setNeedsLayout];
        
        // Let's update the shop info if user is, YOU!
        NSString* userToken = (NSString*)[dict valueForKey:@"userToken"];
        if ([[[FBConfig sharedInstance] userToken] isEqualToString:userToken])
        {
            NSNumber* shopKey = (NSNumber*)[dict valueForKey:@"shopKey"];
            NSNumber* remainingPoints = (NSNumber*)[dict valueForKey:@"remainingPoints"];
            [[ShopInfoService sharedInstance] updateRemainingPoints:remainingPoints forShop:shopKey];
            [FBConfig sharedInstance].refreshShopList = YES;
        }
    }
}


@end
