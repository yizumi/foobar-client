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
@synthesize numberField;
@synthesize userToken;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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


// ================================= ShopLoginViewControllerDelegate =================================
- (void) didLogin:(ShopLoginViewController*)ctrl
{
    NSLog(@"Logged in");
}

- (void) createdShop:(ShopLoginViewController*)ctrl
{
    NSLog(@"Shop created");
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
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([request class] == [FBRedeemPoints class])
    {
        NSNumber* points = (NSNumber*)[response valueForKey:@"remainingPoints"];
        NSString* message = [NSString stringWithFormat:@"残高は%dPt.です", [points intValue]];
        [APCWindow alert:message withTitle:@"ポイント償還完了"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
