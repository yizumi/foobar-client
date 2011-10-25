//
//  ShowCodeViewController.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfoService.h"
#import "APCArray.h"
#import "APCString.h"
#import "FBCodeButton.h"
#import "ShowCodeViewModel.h"
#import "APCRoundRect.h"
#import "FBConfig.h"
#import "BookPointsViewController.h"

@interface ShowCodeViewController : UIViewController
    <UINavigationBarDelegate,FBCommandBaseDelegate>
{
    NSString* _BUTTON_LABELS;
    NSArray* _buttons;
}

- (void) onSegmentChanged:(id)sender;
- (void) onClick:(id)sender;
- (IBAction) onMainButtonPush:(id)sender;
- (IBAction) onExpButtonPush:(id)sender;

@property (nonatomic, retain) IBOutlet FBCodeButton* buttonA;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonB;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonC;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonD;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonE;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonF;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonG;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonH;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonJ;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonK;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonL;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonM;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonN;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonO;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonP;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonQ;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonR;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonS;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonT;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonU;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonV;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonW;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonX;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonY;
@property (nonatomic, retain) IBOutlet FBCodeButton* buttonZ;
@property (nonatomic, retain) IBOutlet UIButton* buttonNavi;
@property (nonatomic, retain) IBOutlet UIButton* buttonRedeem;
@property (nonatomic, retain) IBOutlet UIProgressView* progress;
@property (nonatomic, retain) ShowCodeViewModel* viewModel;


@end
