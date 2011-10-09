//
//  BookPointsViewController.h
//  FooBar
//
//  Created by 泉 雄介 on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APCArray.h"
#import "ASIFormDataRequest.h"
#import "ShopLoginViewController.h"

@interface BookPointsViewController : UIViewController
    <ShopLoginViewControllerDelegate, FBCommandBaseDelegate>
{
    int viewDidAppearCount;
    NSArray* _buttons;
    UILabel *titleLabel;
    UIButton *deleteButton;
    UIButton *backSpaceButton;
    UIButton *buttonGive;
    UIButton *buttonRedeem;
}

- (IBAction)onNumericButtonPushed:(id)sender;
- (IBAction)onCancelPushed:(id)sender;
- (IBAction)onGivePushed:(id)sender;
- (IBAction)onRedeemPushed:(id)sender;
- (IBAction)onClearPushed:(id)sender;
- (IBAction)onBkspPushed:(id)sender;

@property (retain,nonatomic) IBOutlet UIButton* button0;
@property (retain,nonatomic) IBOutlet UIButton* button1;
@property (retain,nonatomic) IBOutlet UIButton* button2;
@property (retain,nonatomic) IBOutlet UIButton* button3;
@property (retain,nonatomic) IBOutlet UIButton* button4;
@property (retain,nonatomic) IBOutlet UIButton* button5;
@property (retain,nonatomic) IBOutlet UIButton* button6;
@property (retain,nonatomic) IBOutlet UIButton* button7;
@property (retain,nonatomic) IBOutlet UIButton* button8;
@property (retain,nonatomic) IBOutlet UIButton* button9;
@property (nonatomic,retain) IBOutlet UIButton* clearButton;
@property (nonatomic,retain) IBOutlet UIButton* backSpaceButton;
@property (nonatomic,retain) IBOutlet UIButton* buttonGive;
@property (nonatomic,retain) IBOutlet UIButton* buttonRedeem;
@property (retain,nonatomic) IBOutlet UITextField* numberField;
@property (retain,nonatomic) NSString* userToken;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end
