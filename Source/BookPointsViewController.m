//
//  BookPointsViewController.m
//  FooBar
//
//  Created by 泉 雄介 on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BookPointsViewController.h"
#import "FBConfig.h"
#import "FBAddPoints.h"
#import "FBRedeemPoints.h"
#import "APCWindow.h"

@implementation BookPointsViewController

@synthesize button0;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize button6;
@synthesize button7;
@synthesize button8;
@synthesize button9;
@synthesize clearButton;
@synthesize backSpaceButton;
@synthesize buttonGive;
@synthesize buttonRedeem;
@synthesize numberField;
@synthesize userToken;
@synthesize titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_buttons forEach:^(id item){
        UIButton* button = (UIButton*)item;
        [button release];
    }];
    [_buttons release];
    [numberField release];
    [userToken release];
    [titleLabel release];
    [deleteButton release];
    [backSpaceButton release];
    [buttonGive release];
    [buttonRedeem release];
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
    
    _buttons = [[NSArray alloc] initWithObjects: 
                button0, 
                button1,
                button2,
                button3, 
                button4,
                button5,
                button6,
                button7,
                button8,
                button9,
                nil];
    
    [_buttons forEach:^(id item){
        UIButton* button = (UIButton*)item;
        [button addTarget:self action:@selector(onNumericButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    // Prepare logout button
    NSString* logout = NSLocalizedString(@"BookPoints_ButtonLogout",@"");
    UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc] initWithTitle:logout
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                     action:@selector(onLogoutPushed:)]autorelease];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    // Set Shop Name
    NSString* shopName = [[FBConfig sharedInstance] shopName];
    [self setTitle:shopName];
    
    // Localization
    titleLabel.text = NSLocalizedString(@"BookPoints_EnterPointsToGiveOrRedeem", @"");
    [buttonGive setTitle:NSLocalizedString(@"BookPoints_ButtonGive",@"") forState:UIControlStateNormal];
    [buttonRedeem setTitle:NSLocalizedString(@"BookPoints_ButtonRedeem",@"") forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    // If user is not logged in, show the login/registration page.
    if (viewDidAppearCount < 1 && [[FBConfig sharedInstance] shopKey] == 0)
    {        
        viewDidAppearCount++;
        ShopLoginViewController* controller = [[ShopLoginViewController alloc]initWithNibName:@"ShopLogin" 
                                                                                 bundle:nil];
        [controller setDelegate:self];
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        NSLog(@"Retain: %d", [controller retainCount]);
        [controller release];
    }
    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setClearButton:nil];
    [self setBackSpaceButton:nil];
    [self setButtonGive:nil];
    [self setButtonRedeem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ============================== IBAction Handlers ===================================

- (IBAction)onCancelPushed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onNumericButtonPushed:(id)sender
{
    UIButton* button = (UIButton*)sender;
    int number = [button.titleLabel.text intValue];
    // now put the number into the calculator.
    int current = [numberField.text intValue];
    int total = (current * 10) + number;
    numberField.text = [NSString stringWithFormat:@"%d", total];
}

- (IBAction)onGivePushed:(id)sender
{
    FBAddPoints* cmd = [[[FBAddPoints alloc] init] autorelease];
    [cmd setDelegate:self];
    cmd.userToken = userToken;
    cmd.points = [NSNumber numberWithInt:[numberField.text intValue]];
    cmd.shopKey = [NSNumber numberWithLong:[[FBConfig sharedInstance] shopKey]];
    
    [cmd execAsync];
}

- (IBAction)onRedeemPushed:(id)sender
{
    FBRedeemPoints* cmd = [[[FBRedeemPoints alloc] init] autorelease];
    [cmd setDelegate:self];
    cmd.redeemToken = userToken;
    cmd.points = [NSNumber numberWithInt:[numberField.text intValue]];
    cmd.shopKey = [NSNumber numberWithLong:[[FBConfig sharedInstance] shopKey]];
    
    [cmd execAsync];
}

- (IBAction)onClearPushed:(id)sender
{
    numberField.text = @"";
}

- (IBAction)onBkspPushed:(id)sender
{
    int current = [numberField.text intValue];
    int newInt = (current / 10);
    numberField.text = [NSString stringWithFormat:@"%d", newInt];
}

- (IBAction)onLogoutPushed:(id)sender
{
    NSString* shopName = [[FBConfig sharedInstance] shopName];
    [[FBConfig sharedInstance] setShopKey:0];
    [[FBConfig sharedInstance] setShopName:nil];
    
    [APCWindow alert:NSLocalizedString(@"BookPoints_LogoutComplete",shopName) withTitle:shopName];
    [self.navigationController popViewControllerAnimated:YES];
}

// ================================= ShopLoginViewControllerDelegate =================================
- (void) didLogin:(ShopLoginViewController*)ctrl
{
    NSLog(@"Logged in");
    [self setTitle:[[FBConfig sharedInstance] shopName]];
}

- (void) createdShop:(ShopLoginViewController*)ctrl
{
    NSLog(@"Shop created");
    [self setTitle:[[FBConfig sharedInstance] shopName]];
}

- (void) didCancel:(ShopLoginViewController*)ctrl
{
    if ([[FBConfig sharedInstance] shopKey] == 0)
    {
        NSLog(@"I'm gonna close myself");
        // [ctrl dismissModalViewControllerAnimated:NO];
        [self dismissModalViewControllerAnimated:NO];
        // [self.parentViewController  dismissModalViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// ================================= FBCommandDelegate =================================
- (void)execSuccess:(id)request withResponse:(id)response
{
    if ([request class] == [FBAddPoints class])
    {
        NSNumber* points = (NSNumber*)[response valueForKey:@"currentPoints"];
        NSString* message = [NSString stringWithFormat:@"残高は%dPt.です", [points intValue]];
        [APCWindow alert:message withTitle:@"ポイント加算完了"];
        [[FBConfig sharedInstance] setRefreshShopList:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([request class] == [FBRedeemPoints class])
    {
        NSNumber* points = (NSNumber*)[response valueForKey:@"remainingPoints"];
        NSString* message = [NSString stringWithFormat:@"残高は%dPt.です", [points intValue]];
        [APCWindow alert:message withTitle:@"ポイント償還完了"];
        [[FBConfig sharedInstance] setRefreshShopList:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
