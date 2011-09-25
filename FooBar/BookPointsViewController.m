//
//  BookPointsViewController.m
//  FooBar
//
//  Created by 泉 雄介 on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BookPointsViewController.h"


@implementation BookPointsViewController

@synthesize button0, button1, button2, button3, button4, button5, button6, button7, button8, button9, numberField;

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
    
    _buttons = [[NSArray alloc] initWithObjects: button0, button1, button2, button3, button4,
                button5, button6, button7, button8, button9, nil];
    
    [_buttons forEach:^(id item){
        UIButton* button = (UIButton*)item;
        [button addTarget:self action:@selector(onNumericButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    }];
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
    NSNumber* points = [NSNumber numberWithInt:[numberField.text intValue]];
    // Setup the Async Shit
    NSURL* url = [NSURL URLWithString:K_URL_GIVE_OR_REDEEM_POINTS];
    __block ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:url];
    [req setPostValue:@"give" forKey:@"action"];
    [req setPostValue:points forKey:@"points"];
    [req setPostValue:[[FBConfig sharedInstance]userLoginToken] forKey:@"from_user_token"];
    [req setPostValue:@"abcde" forKey:@"to_user_token"];
    // If succeed, close the panel
    [req setCompletionBlock:^(void){
        NSString* res = [req responseString];
        NSLog(@"Response: %@",res);
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // If error, show the popup.
    [req setFailedBlock:^(void){
        NSString* res = [req responseString];
        NSLog(@"Something went wrong: %@", res);
        NSError* error = [req error];
        NSLog(@"%@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Error while booking points" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }];
    
    // Send
#if DEBUG
    [req setValidatesSecureCertificate:NO];
#endif
    [req startAsynchronous];
}

- (IBAction)onRedeemPushed:(id)sender
{
    // Setup the async shit
    // Send
    // If succeed, close the panle.
    
    // If error, show the popup.
}

@end
