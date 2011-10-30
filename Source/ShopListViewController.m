//
//  ShopListViewController.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopListViewController.h"
#import "NSObject+SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "FBConfig.h"
#import "ShopInfoService.h"
#import "ShopListCellController.h"
#import "ShopViewController.h"
#import "FBGetShopListForDevice.h"

@implementation ShopListViewController

@synthesize fetchedResults = _fetchedResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ShopListView" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    self.fetchedResults.delegate = nil;
    self.fetchedResults = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Did come here...");
    
    // Refresh Button
    UIBarButtonItem* refresh = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" 
                                                                style:UIBarButtonItemStyleBordered 
                                                               target:self 
                                                               action:@selector(refresh:)];
    
    self.navigationItem.leftBarButtonItem = refresh;
    self.navigationItem.title = @"Points";
    self.fetchedResults = [[ShopInfoService sharedInstance] fetchAll];
    [refresh release];
}

- (void)viewDidAppear:(BOOL)animated
{
    // If app updated the points elsewhere...
    if ([[FBConfig sharedInstance] refreshShopList] == YES)
    {
        // then refresh the list.
        [self refreshShopList];
        // But set the flag false to not update it too frequently.
        [[FBConfig sharedInstance] setRefreshShopList:NO];
    }
}

- (void)refresh:(id)sender
{
    [self refreshShopList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResults = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch(interfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return YES;
        default:
            return NO;
    }
}

// =================================== Helper Methods ==============================
- (void)refreshShopList
{
    FBGetShopListForDevice* cmd = [[[FBGetShopListForDevice alloc] init] autorelease];
    [cmd setDelegate:self];
    cmd.deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    [cmd execAsync];
}

// =================================== UITableViewDelegate ===================================

// Returns the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResults.sections count];
}

// Returns the title for the secion
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = [[[self.fetchedResults sections]objectAtIndex:section] name];
    NSLog(@"Returning Title: %@", title);
    return title;
}

// Returns the number of items in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResults sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Returns the cell for index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopListCell* cell;
    cell = (ShopListCell*)[tableView dequeueReusableCellWithIdentifier:@"ShopListCell"];
    
    if( cell == nil )
    {
        ShopListCellController* ctrl = [[ShopListCellController alloc] initWithNibName:@"ShopListCell" bundle:nil];
        cell = (ShopListCell *)ctrl.view;
        [ctrl release];    
    }
    
    // NSArray* 
    ShopInfo* shop = [self.fetchedResults objectAtIndexPath:indexPath];
    [cell.titleLabel setText: shop.name];
    [cell.pointLabel setText:[[NSString alloc] initWithFormat:@"%d Pt.",[shop.points intValue]]];

    return cell;
}

// Event handler for cell tap
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject* shop = [self.fetchedResults objectAtIndexPath:indexPath];
    ShopViewController* controller = [[ShopViewController alloc] init];
    [controller setManagedObject:shop];
    
    if( controller != nil )
    {
        // NSLog(@"Count: %@", [controller retainCount]);
        [self.navigationController pushViewController:controller animated:YES];
        // NSLog(@"Count: %@", [controller retainCount]);
        [controller release];
    }
}

// =================================== FBCommandBaseDelegate ===================================

- (void) execSuccess:(id)request withResponse:(id)response
{
    if ([request class] == [FBGetShopListForDevice class])
    {
        NSArray* shops = [response objectForKey:@"shops"];
        [[ShopInfoService sharedInstance] updateWithList:shops];
        self.fetchedResults = [[ShopInfoService sharedInstance] fetchAll];
        UITableView* v = (UITableView*)self.view;
        [v reloadData];
    }
}


@end