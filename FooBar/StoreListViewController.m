//
//  StoreListViewController.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreListViewController.h"
#import "StoreListCellController.h"

@implementation StoreListViewController

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
    [refresh release];
}

- (void)refresh:(id)sender
{
    NSLog(@"Came here yo...");
    NSString* deviceId = [[UIDevice currentDevice]uniqueIdentifier];
    NSString* userToken = [[FBConfig sharedInstance]userLoginToken];
    NSURL* url = [NSURL URLWithString:@"https://yizumi.ripplesystem.com/getStoreListForDevice.php"];
    __block ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:url];
    [req setPostValue:deviceId forKey:@"deviceId"];
    [req setPostValue:userToken forKey:@"userToken"];
#if DEBUG
    [req setValidatesSecureCertificate:NO];
#endif
    [req setCompletionBlock:^(void){
        NSString* res = [req responseString];
        NSDictionary* obj = [res JSONValue];
        [[StoreInfoManager sharedInstance]refreshListWith:obj];
    }];
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
    [req startAsynchronous];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[StoreInfoManager sharedInstance] stores] count];
}

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
    StoreInfo* store = [[[StoreInfoManager sharedInstance] stores] objectAtIndex:indexPath.row];
    [cell.titleLabel setText: store.name];
    [cell.pointLabel setText:[[NSString alloc] initWithFormat:@"%d Pt.",[store.points intValue]]];

    return cell;
}


@end
