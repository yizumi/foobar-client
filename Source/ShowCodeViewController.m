//
//  ShowCodeViewController.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowCodeViewController.h"
#import "FBConfig.h"
#import "FBGetRedeemToken.h"
#import "APCDateUtil.h"

@implementation ShowCodeViewController

@synthesize buttonA;
@synthesize buttonB;
@synthesize buttonC;
@synthesize buttonD;
@synthesize buttonE;
@synthesize buttonF;
@synthesize buttonG;
@synthesize buttonH;
@synthesize buttonJ;
@synthesize buttonK;
@synthesize buttonL;
@synthesize buttonM;
@synthesize buttonN;
@synthesize buttonO;
@synthesize buttonP;
@synthesize buttonQ;
@synthesize buttonR;
@synthesize buttonS;
@synthesize buttonT;
@synthesize buttonU;
@synthesize buttonV;
@synthesize buttonW;
@synthesize buttonX;
@synthesize buttonY;
@synthesize buttonZ;
@synthesize buttonNavi;
@synthesize buttonRedeem;
@synthesize progress;
@synthesize viewModel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        ShowCodeViewModel* vm = [[ShowCodeViewModel alloc]init];
        viewModel = vm;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ShowCodeViewModel* vm = [[ShowCodeViewModel alloc]init];
        viewModel = vm;
    }
    return self;
}

/*
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize view model
    [viewModel addObserver:self 
                forKeyPath:@"mode" 
                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                   context:nil];
    [viewModel addObserver:self 
                 forKeyPath:@"instruction" 
                    options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                    context:nil];
    [viewModel addObserver:self 
                forKeyPath:@"tokenDisplay" 
                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                   context:nil];
    [viewModel addObserver:self
                forKeyPath:@"remainingTimeInSec"
                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                   context:nil];

    // Attach the event handler on segmentedControl buttons (Toggles b/w take and give)
    UISegmentedControl* segmentedControl = (UISegmentedControl *)self.navigationItem.titleView;
    [segmentedControl addTarget:self 
                         action:@selector(onSegmentChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    // Initialize
    _buttons = [[NSArray alloc] initWithObjects: buttonA, buttonB, buttonC, buttonD, buttonE, 
                                                 buttonF, buttonG, buttonH, buttonJ, buttonK,
                                                 buttonL, buttonM, buttonN, buttonO, buttonP, 
                                                 buttonQ, buttonR, buttonS, buttonT, buttonU,
                                                 buttonV, buttonW, buttonX, buttonY, buttonZ, nil];
    // Attach delegate on buttons
    [_buttons forEach:^(id item){
        FBCodeButton* button = (FBCodeButton*)item;
        [button setChecked:NO]; // initialize with no state.
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
    }];
    
    NSLog(@"Current Mode: %@", viewModel.mode);
    [viewModel setValue:viewModel.mode forKey:@"mode"];
    [viewModel setValue:viewModel.tokenDisplay forKey:@"tokenDisplay"];
    [viewModel setValue:viewModel.instruction forKey:@"instruction"];
}

- (void)viewDidUnload
{
    NSLog(@"I'm being unloaded");
    // Assumes we have 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Starting timer");
    [viewModel beginExpirationTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"Stopping timer");
    [viewModel stopExpirationTimer];
}

- (void)dealloc
{    
    NSLog(@"I'm being cleaned up");
    [viewModel removeObserver:self forKeyPath:@"mode"];
    [viewModel removeObserver:self forKeyPath:@"instruction"];
    [viewModel removeObserver:self forKeyPath:@"tokenDisplay"];
    [viewModel removeObserver:self forKeyPath:@"remainingTimeInSec"];
    
    [_buttons forEach:^(id button){ [button release]; }];
    [_buttons release];
    [buttonNavi release];
    [buttonRedeem release];
    [progress release];
    [viewModel release];
    [super dealloc];
}


// Okay. this is the place where you want to put the logic
// to handle property changes on the view model.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // The display token has changed.
    // Update the button
    if ([keyPath isEqual:@"tokenDisplay"])
    {
        NSString* newToken = (NSString *)[change objectForKey:NSKeyValueChangeNewKey];
        [_buttons forEach:^(id item) {
            FBCodeButton* button = (FBCodeButton*)item;
            NSString* origTitle = [button getOrigTitle];
            int index = [newToken indexOf:[origTitle characterAtIndex:0]];
            NSString* title = index > -1 ? [NSString stringWithFormat:@"%d", index+1] : origTitle;
            [button setChecked: index > -1 withTitle:title];
        }];
    }
    else if ([keyPath isEqual:@"instruction"])
    {
        NSString* newInstruction = (NSString*)[change objectForKey:NSKeyValueChangeNewKey];
        [self.buttonNavi setTitle:newInstruction forState:UIControlStateNormal];
    }
    else if ([keyPath isEqual:@"mode"] )
    {
        switch( [viewModel.mode intValue] )
        {
            case K_MODE_TAKE:
                [buttonNavi setHidden:NO];
                [buttonRedeem setHidden:YES];
                [progress setHidden:YES];
                break;
            case K_MODE_GIVE:
                [buttonNavi setHidden:NO];
                [buttonRedeem setHidden:YES];
                [progress setHidden:YES];
                break;
            case K_MODE_REDEEM:
                [buttonNavi setHidden:YES];
                [buttonRedeem setHidden:NO];
                [progress setHidden:NO];
                break;
            default:
                /*
                 Be sure to call the superclass's implementation *if it implements it*.
                 NSObject does not implement the method.
                 */
                [super observeValueForKeyPath:keyPath
                                     ofObject:object
                                       change:change
                                      context:context];
        }
    }
    else if ([keyPath isEqual:@"remainingTimeInSec"])
    {
        NSNumber* remTimeInSec = (NSNumber*)[change objectForKey:NSKeyValueChangeNewKey];
        if ([remTimeInSec doubleValue] > 0)
        {
            float threeHrs = (180 * 60);
            float rate = [remTimeInSec floatValue] / threeHrs;
            NSLog(@"What's the shiznit: %@ / rate: %f", remTimeInSec, rate);
            [progress setProgress:rate];
            int min = [remTimeInSec intValue] / 60;
            int sec = [remTimeInSec intValue] % 60;
            NSString* instructionTmp = NSLocalizedString(@"ShowCodeView_Expiration", @"");
            NSString* instruction = [NSString stringWithFormat:instructionTmp, min, sec];
            NSLog(@"Instruction: %@", instruction);
            [buttonRedeem setTitle:instruction forState:UIControlStateNormal];
        }
        else
        {
            [progress setProgress:0];
            [buttonRedeem setTitle:NSLocalizedString(@"ShowCodeView_Expired",@"") forState:UIControlStateNormal];
        }
    }
}


// ================================= EVENT HANDLERS =================================
- (void)onClick:(id)sender
{
    FBCodeButton* button = (FBCodeButton*)sender;
    if( [viewModel.mode intValue] == K_MODE_GIVE )
    {
        NSString* origTitle = [button getOrigTitle];
        NSLog(@"User pressed '%@'", origTitle);
        [viewModel toggleInputTokenChar:[origTitle characterAtIndex:0]];
        [viewModel setValue:viewModel.tokenInput forKey:@"tokenDisplay"];
        NSLog(@"Display token: %@ / Input token: %@", viewModel.tokenDisplay, viewModel.tokenInput);
    }
}

- (void)onSegmentChanged:(id)sender
{
    UISegmentedControl* segmentedControl = (UISegmentedControl *)sender;
    NSLog(@"Someone is touching me: %d", segmentedControl.selectedSegmentIndex);
    [viewModel setValue:[NSNumber numberWithInt:segmentedControl.selectedSegmentIndex] forKey:@"mode"];
    switch( segmentedControl.selectedSegmentIndex )
    {
        // For TAKE
        case 0:
            [viewModel setValue:[[FBConfig sharedInstance]userToken] forKey:@"tokenDisplay"];
            break;
        // For GIVE
        case 1:
            [viewModel setValue:@"" forKey:@"tokenDisplay"];
            break;
    }
}

- (IBAction)onMainButtonPush:(id)sender
{
    if( [viewModel.mode intValue] == K_MODE_GIVE )
    {
        // Main button should transition to book points screen
        if( [viewModel.isTokenInputValid boolValue] )
        {
            UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:nil
                                                                          action:nil];
            self.navigationItem.backBarButtonItem = backButton;
            [backButton release];

            BookPointsViewController* controller = [[BookPointsViewController alloc]initWithNibName:@"BookPoints" 
                                                                                             bundle:nil];
            controller.userToken = viewModel.tokenInput;
            // controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
}

- (IBAction) onExpButtonPush:(id)sender
{
    if ([viewModel.mode intValue] == K_MODE_REDEEM)
    {
        // Main button for redeem should refresh the token
        FBGetRedeemToken* cmd = [[[FBGetRedeemToken alloc] init] autorelease];
        [cmd setDelegate:self];
        cmd.shopKey = viewModel.shopKey;
        [cmd execAsync];
    }
}

// =================================== FBCommandBaseDelegate ========================================

- (void)execSuccess:(id)request withResponse:(id)response
{
    if ([request class] == [FBGetRedeemToken class])
    {
        // Shop Key...
        NSNumber* shopKey = viewModel.shopKey;
        
        // Extract variables
        NSString* redeemToken = (NSString*)[response valueForKey:@"redeemToken"];
        NSString* expirationStr = (NSString*)[response valueForKey:@"expiration"];
        NSDate* expiration = (NSDate*)[APCDateUtil dateWithString:expirationStr];
        
        // Update the shop info using shop manager
        [[FBShopManager sharedInstance] updateShopRedeemToken:redeemToken
                                                andExpiration:expiration
                                                      forShop:shopKey];
        
        // Update view model's token
        viewModel.tokenDisplay = redeemToken;
        viewModel.expirationDate = expiration;        
    }
}

@end
