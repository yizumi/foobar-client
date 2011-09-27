//
//  StoreListViewController.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreListViewController.h"
#import "NSObject+SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "FBConfig.h"
#import "FBStoreManager.h"
#import "StoreListCellController.h"
#import "StoreViewController.h"

@implementation StoreListViewController

@synthesize fetchedResults = _fetchedResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"StoreListView" bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

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
    self.fetchedResults = [[FBStoreManager sharedInstance] fetchStoreInfos];
    [refresh release];
}

- (void)refresh:(id)sender
{
    NSString* deviceId = [[UIDevice currentDevice]uniqueIdentifier];
    NSString* userToken = [[FBConfig sharedInstance] userToken];
    NSURL* url = [NSURL URLWithString:K_URL_GET_STORE_LIST_FOR_DEVICE];
    __block ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:url];
    [req setPostValue:deviceId forKey:@"deviceId"];
    [req setPostValue:userToken forKey:@"userToken"];
    // Invoked up on successful completion
    [req setCompletionBlock:^(void){
        NSString* res = [req responseString];
        NSLog(@"Response: %@", res);
        NSArray* storeList = [res JSONValue];
        [[FBStoreManager sharedInstance]updateWithList:storeList];
        // Need to refresh the view list here...
        self.fetchedResults = [[FBStoreManager sharedInstance] fetchStoreInfos];
        UITableView* v = (UITableView*)self.view;
        [v reloadData];
    }];
    // Invoked up on failure
    [req setFailedBlock:^(void) {
        NSError* error = [req error];
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Error while getting store list" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }];

    // Send the request
#if DEBUG
    [req setValidatesSecureCertificate:NO];
#endif
    [req startAsynchronous];
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
    StoreListCell* cell;
    cell = (StoreListCell*)[tableView dequeueReusableCellWithIdentifier:@"StoreListCell"];
    
    if( cell == nil )
    {
        StoreListCellController* ctrl = [[StoreListCellController alloc] initWithNibName:@"StoreListCell" bundle:nil];
        cell = (StoreListCell *)ctrl.view;
        [ctrl release];    
    }
    
    // NSArray* 
    FBStore* store = [self.fetchedResults objectAtIndexPath:indexPath];
    [cell.titleLabel setText: store.name];
    [cell.pointLabel setText:[[NSString alloc] initWithFormat:@"%d Pt.",[store.points intValue]]];

    return cell;
}

// Event handler for cell tap
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject* store = [self.fetchedResults objectAtIndexPath:indexPath];
    StoreViewController* controller = [[StoreViewController alloc] init];
    [controller setManagedObject:store];
    
    if( controller != nil )
    {
        // NSLog(@"Count: %@", [controller retainCount]);
        [self.navigationController pushViewController:controller animated:YES];
        // NSLog(@"Count: %@", [controller retainCount]);
        [controller release];
    }
}


@end