//
//  StoreViewController.m
//  foobar
//
//  Created by 泉 雄介 on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreViewController.h"
#import "ContactCell.h"
#import "ASIHTTPRequest.h"
#import "APCString.h"
#import "APCDateUtil.h"
#import "ShowCodeViewController.h"
#import "ShowCodeViewModel.h"
#import "NSObject+SBJson.h"

@implementation StoreViewController

@synthesize managedObject = _managedObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"StoreView" bundle:nil];
    if (self) {
        _managedObject = nil;
    }
    return self;
}

- (void)dealloc
{
    [_managedObject release];
    [super dealloc];
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
    NSString* name = (NSString*)[_managedObject valueForKey:@"name"];
    NSLog(@"Name: %@",name);
    [self setTitle:name];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Returns the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

// Returns the title for the secion
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
        case 1:
            return @"ポイント";
        case 2:
            return @"連絡先";
        default:
            return @"";
    }
}

// Returns the number of items in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 2;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch( indexPath.section )
    {
        case 0:
            return 124;
        default:
            return 44;
    }
}

// Returns the cell for index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ==== General Info Section ====
    if( indexPath.section == 0 )
    {
        StoreViewCell* cell;
        cell = (StoreViewCell*)[tableView dequeueReusableCellWithIdentifier:@"StoreViewCell"];
        if( cell == nil )
        {
            UIViewController* ctrl = [[UIViewController alloc] initWithNibName:@"StoreViewCell"
                                                                        bundle:nil];
            cell = (StoreViewCell *)ctrl.view;
            [ctrl release];
        }
        cell.nameLabel.text = [_managedObject valueForKey:@"name"];
        NSNumber* points = (NSNumber*)[_managedObject valueForKey:@"points"];
        NSString* pointsStr = [[[NSString alloc] initWithFormat:@"%d Pt.", [points intValue]]autorelease];
        cell.pointsLabel.text = pointsStr;
        [self setImage:[_managedObject valueForKey:@"imageUrl"] on:cell];
        return cell;
    }
    
    // ==== Points Section ====
    if (indexPath.section == 1)
    {
        ContactCell* cell;
        cell = (ContactCell*)[tableView dequeueReusableCellWithIdentifier:@"Contact Cell"];
        if (cell == nil)
        {
            UIViewController* ctrl = [[UIViewController alloc]initWithNibName:@"ContactCell" 
                                                                       bundle:nil];
            cell = (ContactCell*)ctrl.view;
            [ctrl release];
        }
        
        switch (indexPath.row) {
            case 0:
                cell.labelType.text = @"残高";
                NSNumber* points = (NSNumber*)[_managedObject valueForKey:@"points"];
                NSString* pointsStr = [[[NSString alloc] initWithFormat:@"%d Pt.", [points intValue]]autorelease];
                cell.labelInfo.text = pointsStr;
                cell.labelAction.text = @"使う";
            default:
                break;
        }
        
        return cell;
    }
    
    // ==== Contact Info Section ====
    if( indexPath.section == 2)
    {
        ContactCell* cell;
        cell = (ContactCell*)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if( cell == nil )
        {
            UIViewController* ctrl = [[UIViewController alloc] initWithNibName:@"ContactCell" 
                                                                        bundle:nil];
            cell = (ContactCell*)ctrl.view;
            [ctrl release];
        }
        
        switch(indexPath.row)
        {
            case 0:
                cell.labelType.text = @"電話";
                cell.labelInfo.text = [_managedObject valueForKey:@"tel"];
                cell.labelAction.text = @"> Call";
                break;
            case 1:
                cell.labelType.text = @"住所";
                cell.labelInfo.text = [_managedObject valueForKey:@"address"];
                cell.labelAction.text = @"> Map";
                break;
        }
        return cell;
    }
    
    return nil;
}

- (void) setImage:(NSString*) urlString on:(StoreViewCell*) cell
{
    NSURL* url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:url];
    // Invoked up on successful completion
    [req setCompletionBlock:^(void){
        NSData* data = [req responseData];
        cell.imageView.image = [UIImage imageWithData:data];
        [cell setNeedsLayout];
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
    
    [req startAsynchronous];
}

// Event handler for cell tap
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            // Link to Redeem Points screen
            case 0:
                {
                    [self getRedeemToken];
                }
                break;
        }
    }
    if(indexPath.section == 2)
    {
        switch(indexPath.row)
        {
            // Link to map.
            case 1:
                {
                    NSString* address = (NSString*)[_managedObject valueForKey:@"address"];
                    NSString* urlStr = [NSString stringWithFormat:K_URL_MAP, [address urlEncode]];
                    NSURL *url = [NSURL URLWithString:urlStr];
                    [[UIApplication sharedApplication]openURL:url];
                    NSLog(@"Hi: %@", urlStr);
                }
                break;
            default:
                break;
        }
    }
}

- (void)showCodeViewWithToken:(NSString*)token
{
    ShowCodeViewController* ctrl;
    ctrl = [[ShowCodeViewController alloc]initWithNibName:@"ShowCodeView" 
                                                   bundle:nil];
    ShowCodeViewModel* viewModel;
    viewModel = (ShowCodeViewModel*)ctrl.viewModel;
    [viewModel setValue:[NSNumber numberWithInt:K_MODE_REDEEM] forKey:@"mode"]; // Set the mode to "REDEEM"
    NSString* identifier = (NSString*)[_managedObject valueForKey:@"identifier"];
    [viewModel setValue:identifier forKey:@"storeId"];
    
    // Show the control
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

// Redeem token, then display the shiznitRedeemTokenDisplay
- (void) getRedeemToken
{
    NSString* token = (NSString*)[_managedObject valueForKey:@"redeemToken"];
    NSDate* exp = (NSDate*)[_managedObject valueForKey:@"redeemTokenExpiration"];
    if( token != nil && exp != nil )
    {
        NSTimeInterval span = [exp timeIntervalSinceNow];
        if (span > 0)
        {
            [self showRedeemTokenView:token withExpiration:exp];
            return;
        }
    }
    
    // Initialize values to send
    NSString* storeId = (NSString*)[_managedObject valueForKey:@"address"];
    NSString* deviceId = [[FBConfig sharedInstance] deviceToken];

    // Create URL, Request and Send the Request
    NSURL* url = [NSURL URLWithString:K_URL_GET_REDEEM_TOKEN];
    __block ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:url];
    [req setPostValue:deviceId forKey:@"deviceId"];
    [req setPostValue:storeId forKey:@"storeId"];
    [req setCompletionBlock:^(void){
        NSString* responseString = [req responseString];
        NSDictionary* obj = [responseString JSONValue];
        if (obj==nil) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                           message:@"Could not issue redeem token"
                                                          delegate:nil
                                                 cancelButtonTitle:nil 
                                                 otherButtonTitles:@"OK", nil];
            [alert show];
            [alert autorelease];
            return;
        }
        NSString* redeemToken = [obj objectForKey:@"redeemToken"];
        NSString* expDateStr = [obj objectForKey:@"expirationDate"];
        NSString* identifier = (NSString*)[_managedObject valueForKey:@"identifier"];
        NSDate* expirationDate = [APCDateUtil dateWithString:expDateStr];
        NSLog(@"RedeemToke: %@, ExpirationDate: %@", redeemToken, expirationDate);
        [[FBStoreManager sharedInstance] updateStoreRedeemToken:redeemToken
                                                  andExpiration:expirationDate 
                                                       forStore:identifier];         
        [self showRedeemTokenView:redeemToken withExpiration:expirationDate];
    }];
    [req setFailedBlock:^(void){
        NSError* error = [req error];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:@"Failed to issue redeem token"
                                                      delegate:nil
                                             cancelButtonTitle:nil 
                                             otherButtonTitles:@"OK", nil];
        [alert show];
        [alert autorelease];
        NSLog(@"Error while getting redeem token from server: %@",error);
    }];
    
    // Send the Request
#if DEBUG
    [req setValidatesSecureCertificate:NO];
#endif
    [req startAsynchronous];    
}

- (void) showRedeemTokenView:(NSString*)redeemToken withExpiration:(NSDate*)expirationDate
{
    // Now get the shiznit
    ShowCodeViewController* controller = [[ShowCodeViewController alloc]initWithNibName:@"ShowCodeView" 
                                                                                 bundle:nil];
    ShowCodeViewModel* viewModel = controller.viewModel;
    [viewModel setValue:[NSNumber numberWithInt:K_MODE_REDEEM] forKey:@"mode"];
    [viewModel setValue:redeemToken forKey:@"tokenDisplay"];
    [viewModel setValue:expirationDate forKey:@"expirationDate"];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end



















