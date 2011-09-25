//
//  ShowCodeViewController.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowCodeViewController.h"

@implementation ShowCodeViewController

@synthesize buttonNavi = _buttonNavi;
@synthesize buttonA = _buttonA;
@synthesize buttonB = _buttonB;
@synthesize buttonC = _buttonC;
@synthesize buttonD = _buttonD;
@synthesize buttonE = _buttonE;
@synthesize buttonF = _buttonF;
@synthesize buttonG = _buttonG;
@synthesize buttonH = _buttonH;
@synthesize buttonJ = _buttonJ;
@synthesize buttonK = _buttonK;
@synthesize buttonL = _buttonL;
@synthesize buttonM = _buttonM;
@synthesize buttonN = _buttonN;
@synthesize buttonO = _buttonO;
@synthesize buttonP = _buttonP;
@synthesize buttonQ = _buttonQ;
@synthesize buttonR = _buttonR;
@synthesize buttonS = _buttonS;
@synthesize buttonT = _buttonT;
@synthesize buttonU = _buttonU;
@synthesize buttonV = _buttonV;
@synthesize buttonW = _buttonW;
@synthesize buttonX = _buttonX;
@synthesize buttonY = _buttonY;
@synthesize buttonZ = _buttonZ;

const int kModeTake = 0;
const int kModeGive = 1;

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
    [_buttonNavi release];
    [_buttons forEach:^(id button){ [button release]; }];
    [_buttons release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    // Assumes we have 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize view model
    _viewModel = [[ShowCodeViewModel alloc]init];
    [_viewModel addObserver:self 
                 forKeyPath:@"tokenDisplay" 
                    options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                    context:nil];
    [_viewModel addObserver:self 
                 forKeyPath:@"mode" 
                    options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                    context:nil];
    [_viewModel addObserver:self 
                 forKeyPath:@"instruction" 
                    options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                    context:nil];

    // Attach the event handler on segmentedControl buttons (Toggles b/w take and give)
    UISegmentedControl* segmentedControl = (UISegmentedControl *)self.navigationItem.titleView;
    [segmentedControl addTarget:self 
                         action:@selector(onSegmentChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    // Initialize
    _buttons = [[NSArray alloc] initWithObjects: _buttonA, _buttonB, _buttonC, _buttonD, _buttonE, 
                                                 _buttonF, _buttonG, _buttonH, _buttonJ, _buttonK,
                                                 _buttonL, _buttonM, _buttonN, _buttonO, _buttonP, 
                                                 _buttonQ, _buttonR, _buttonS, _buttonT, _buttonU,
                                                 _buttonV, _buttonW, _buttonX, _buttonY, _buttonZ, nil];
    // Attach delegate on buttons
    [_buttons forEach:^(id item){
        FBCodeButton* button = (FBCodeButton*)item;
        [button setChecked:NO]; // initialize with no state.
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
    }];
    
    [_viewModel setValue:[NSNumber numberWithInt:kModeTake] forKey:@"mode"];
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
            int index = [newToken indexOf:[button.titleLabel.text characterAtIndex:0]];
            [button setChecked: index > -1];            
        }];
    }
    else if ([keyPath isEqual:@"instruction"])
    {
        NSString* newInstruction = (NSString*)[change objectForKey:NSKeyValueChangeNewKey];
        [self.buttonNavi setTitle:newInstruction forState:UIControlStateNormal];
    }
    else if ([keyPath isEqual:@"mode"] )
    {
        switch( [_viewModel.mode intValue] )
        {
            case 0:
                // Do something to 
                break;
            case 1:
                // Here, collapse the label.
                /*
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.5];
                [UIView commitAnimations];
                */
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
}


/***************************************
 * Event Handlers
 ***************************************/
- (void)onClick:(id)sender
{
    FBCodeButton* button = (FBCodeButton*)sender;
    if( [_viewModel.mode intValue] == kModeGive )
    {
        NSLog(@"User pressed '%@'", button.titleLabel.text);
        [_viewModel toggleInputTokenChar:[button.titleLabel.text characterAtIndex:0]];
        [_viewModel setValue:_viewModel.tokenInput forKey:@"tokenDisplay"];
        NSLog(@"Display token: %@ / Input token: %@", _viewModel.tokenDisplay, _viewModel.tokenInput);
    }
}

- (void)onSegmentChanged:(id)sender
{
    UISegmentedControl* segmentedControl = (UISegmentedControl *)sender;
    NSLog(@"Someone is touching me: %d", segmentedControl.selectedSegmentIndex);
    [_viewModel setValue:[NSNumber numberWithInt:segmentedControl.selectedSegmentIndex] forKey:@"mode"];
    switch( segmentedControl.selectedSegmentIndex )
    {
        // For TAKE
        case 0:
            [_viewModel setValue:[FBConfig sharedInstance].userLoginToken forKey:@"tokenDisplay"];
            break;
        // For GIVE
        case 1:
            [_viewModel setValue:@"" forKey:@"tokenDisplay"];
            break;
    }
}

- (IBAction)onMainButtonPush:(id)sender
{
    if( [_viewModel.mode intValue] == 1 )
    {
        if( [_viewModel.isTokenInputValid boolValue] )
        {
            // Well, now I want to Open the View to enter points and send.
            // What should I do?
#if DEBUG
            NSLog(@"Let's do it");
#endif
            BookPointsViewController* controller = [[BookPointsViewController alloc]initWithNibName:@"BookPoints" 
                                                                                                 bundle:nil];
            controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            // controller.delegate = self;
            [self presentModalViewController:controller animated:YES];
            [controller release];
        }
    }

}

@end
