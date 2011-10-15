//
//  ShopLoginViewController.m
//  foobar
//
//  Created by 泉 雄介 on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopLoginViewController.h"
#import "TextFormCell.h"
#import "ImageFormCell.h"
#import "ASIFormDataRequest.h"
#import "FBConfig.h"
#import "NSObject+SBJson.h"
#import "FBLoginShop.h"
#import "FBCreateShop.h"
#import "APCWindow.h"
#import "FBCommandBase.h"
#import "APCImage.h"

@implementation ShopLoginViewController

@synthesize loginEmail;
@synthesize loginPassword;
@synthesize registName;
@synthesize registAddress;
@synthesize registTel;
@synthesize registUrl;
@synthesize registEmail;
@synthesize registPassword;
@synthesize delegate;
@synthesize registImageData;
@synthesize shopImage;


- (void)viewDidLoad
{
    [self setTitle:@"ショップログイン"];
}

- (void) dealloc
{
    [loginEmail release];
    [loginPassword release];
    [registName release];
    [registAddress release];
    [registTel release];
    [registUrl release];
    [registEmail release];
    [registPassword release];
    [registImageData release];
    [shopImage release];
    // [delegate release];
    [super dealloc];
}

// ==================== UITableViewDelegate implementation ====================

// Returns the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

// Returns the title for the secion
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"アカウントをお持ちの方";
        case 2:
            return @"ショップの新規登録";
        default:
            return @"";
    }
}

// Returns the number of items in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2; // email , password
        case 1:
            return 1; // login button
        case 2:
            return 6; // name, telephone, address, url, email, password
        case 3:
            return 1; // image upload
        case 4:
            return 1; // register button
        case 5:
            return 1; // cancel button
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch( indexPath.section )
    {
        default:
            return 44;
    }
}

// Returns the cell for index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* required = NSLocalizedString(@"ShopLogin_Required",@"");
    
    // ==== Login Section ====
    if( indexPath.section == 0 )
    {
        TextFormCell* cell;
        cell = (TextFormCell*)[tableView dequeueReusableCellWithIdentifier:@"TextFormCell"];
        if( cell == nil )
        {
            UIViewController* ctrl = [[UIViewController alloc] initWithNibName:@"TextFormCell"
                                                                        bundle:nil];
            cell = (TextFormCell *)ctrl.view;
            [ctrl release];
        }
        switch (indexPath.row)
        {
            case 0:
                cell.titleLabel.text = @"Eメール";
                cell.textField.text = loginEmail;
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.tag = 0;
                break;
            case 1:
                cell.titleLabel.text = @"パスワード";
                cell.textField.text = loginPassword;
                cell.textField.secureTextEntry = YES;
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.tag = 1;
        }

        // So that this becomes the listener to close the keyboard when done.
        cell.textField.placeholder = required;
        [cell.textField setDelegate:self];
        return cell;
    }
    
    // ==== Registration Section ====
    if (indexPath.section == 2)
    {
        TextFormCell* cell;
        cell = (TextFormCell*)[tableView dequeueReusableCellWithIdentifier:@"TextFormCell"];
        if (cell == nil)
        {
            UIViewController* ctrl = [[UIViewController alloc] initWithNibName:@"TextFormCell"
                                                                        bundle:nil];
            cell = (TextFormCell *)ctrl.view;
            [ctrl release];
        }
    
        switch (indexPath.row) {
            case 0: //name
                cell.titleLabel.text = @"ショップ名";
                cell.textField.text = registName;
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.placeholder = required;
                cell.textField.tag = 10;
                break;
            case 1: // address
                cell.titleLabel.text = @"住所";
                cell.textField.text = registAddress;
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.placeholder = required;
                cell.textField.tag = 11;
                break;
            case 2: // tel
                cell.titleLabel.text = @"電話番号";
                cell.textField.text = registTel;
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.placeholder = required;
                cell.textField.tag = 12;
                break;
            case 3: // url
                cell.titleLabel.text = @"ホームページ";
                cell.textField.text = registUrl;
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.keyboardType = UIKeyboardTypeURL;
                cell.textField.tag = 13;
                break;
            case 4: // email
                cell.titleLabel.text = @"メールアドレス";
                cell.textField.text = registEmail;
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
                cell.textField.placeholder = required;
                cell.textField.tag = 14;
                break;
            case 5: // password
                cell.titleLabel.text = @"パスワード";
                cell.textField.text = registPassword;
                cell.textField.secureTextEntry = YES;
                cell.textField.keyboardType = UIKeyboardTypeAlphabet;
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.placeholder = required;
                cell.textField.tag = 15;
                break;
            default:
                cell.titleLabel.text = [NSString stringWithFormat:@"Word: %d", indexPath.row];
                break;
        }
        [cell.textField setDelegate:self];
        return cell;
    }
    
    // Image upload
    if (indexPath.section == 3)
    {
        ImageFormCell* cell;
        cell = (ImageFormCell*)[tableView dequeueReusableCellWithIdentifier:@"ImageFormCell"];
        if (cell == nil)
        {
            UIViewController* ctrl = [[UIViewController alloc] initWithNibName:@"ImageFormCell"
                                                                        bundle:nil];
            cell = (ImageFormCell *)ctrl.view;
            [ctrl release];
        }
        cell.titleLabel.text = NSLocalizedString(@"ShopLogin_ShopImage",@"");
        cell.imageView.image = shopImage;
        return cell;
    }
    
    // Must be a button if it reaches here
    UITableViewCell* cell;
    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] init] autorelease];
    }

    switch (indexPath.section)
    {
        case 1: cell.textLabel.text = @"ログイン"; break;
        case 4: cell.textLabel.text = @"登録"; break;
        case 5: cell.textLabel.text = @"キャンセル"; break;
    }    
    return cell;
}

// Event handler for cell tap
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1)
    {
        FBLoginShop* cmd = [[[FBLoginShop alloc] init] autorelease];
        [cmd setDelegate:self];
        cmd.email = loginEmail;
        cmd.password = loginPassword;
        [cmd execAsync];
    }
    
    // For Image Upload
    if (indexPath.section == 3)
    {
        NSString* sCancel = NSLocalizedString(@"ShopLogin_ButtonCancel",@"");
        UIActionSheet *sheet;
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:self 
                                   cancelButtonTitle:sCancel
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil];

        // Add buttons for each type of image picker source
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            _cameraButtonIndex = 
                [sheet addButtonWithTitle:NSLocalizedString(@"ShopLogin_ButtonCamera",@"")];
        else
            _cameraButtonIndex = -1;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            _photoLibButtonIndex = 
                [sheet addButtonWithTitle:NSLocalizedString(@"ShopLogin_ButtonPhotoLibrary",@"")];
        else
            _photoLibButtonIndex = -1;

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            _photoAlbumButtonIndex = 
                [sheet addButtonWithTitle:NSLocalizedString(@"ShopLogin_ButtonPhotoAlbum",@"")];
        else
            _photoAlbumButtonIndex = -1;
        
        [sheet showInView:[self view]];
        [sheet release];        
    }
    
    if(indexPath.section == 4)
    {
        FBCreateShop* cmd = [[[FBCreateShop alloc] init] autorelease];
        
        NSString* errormsg = nil;
        if (registPassword == nil) errormsg = @"パスワードを入力してください";
        if (registEmail == nil) errormsg = @"メールアドレスを入力してください";
        if (registTel == nil) errormsg = @"電話番号を入力してください";
        if (registAddress == nil) errormsg = @"住所を入力してください";
        if (registName == nil) errormsg = @"ショップ名を入力してください";
        if (errormsg != nil)
        {
            [APCWindow alert:errormsg];
            return;
        }

        [cmd setDelegate:self];
        cmd.name = registName;
        cmd.address = registAddress;
        cmd.tel = registTel;
        cmd.url = registUrl;
        cmd.image = registImageData;
        cmd.email = registEmail;
        cmd.password = registPassword;
        cmd.preferredLang = [[NSLocale currentLocale] localeIdentifier];
        NSLog(@"Current locale: %@", cmd.preferredLang);
        [cmd execAsync];
    }
    
    if (indexPath.section == 5)
    {
        [self.delegate didCancel:self];
    }
}

// ==================== UITextFieldDelegate ====================
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Text[%d] = %@", textField.tag, textField.text);
    switch (textField.tag)
    {
        case 0: self.loginEmail = textField.text; break;
        case 1: self.loginPassword = textField.text; break;
        case 10: self.registName = textField.text; break;
        case 11: self.registAddress = textField.text; break;
        case 12: self.registTel = textField.text; break;
        case 13: self.registUrl = textField.text; break;
        case 14: self.registEmail = textField.text; break;
        case 15: self.registPassword = textField.text; break;
    }
}

// ==================== FBCommandBaseDelegate ====================
- (void)execSuccess:(id)request withResponse:(id)response
{
    if ([request class] == [FBLoginShop class])
    {
        // Set shopKey
        NSLog(@"Login Success");
        NSNumber* shopKey = (NSNumber*)[response valueForKey:@"shopKey"];
        NSString* shopName = (NSString*)[[response valueForKey:@"shop"] valueForKey:@"name"];
        [[FBConfig sharedInstance] setShopKey:[shopKey longValue]];
        [[FBConfig sharedInstance] setShopName:shopName];
        [delegate didLogin:self];
        [self dismissModalViewControllerAnimated:YES];
    }
    else if ([request class] == [FBCreateShop class])
    {
        // Set shopKey
        NSNumber* shopKey = (NSNumber*)[response valueForKey:@"shopKey"];
        NSString* shopName = (NSString*)[[response valueForKey:@"shop"] valueForKey:@"name"];
        [[FBConfig sharedInstance] setShopKey:[shopKey longValue]];
        [[FBConfig sharedInstance] setShopName:shopName];
        [delegate createdShop:self];
        [self dismissModalViewControllerAnimated:YES];
    }
}

// =================== UIActionSheetDelegate ====================
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* picker;
    picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;

    if (buttonIndex == _cameraButtonIndex)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else if(buttonIndex == _photoLibButtonIndex)
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    else if(buttonIndex == _photoAlbumButtonIndex)
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:picker animated:YES];
}

// =================== UIImagePickerControllerDelegate ===================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    CGFloat MAX_WIDTH = 250;
    CGFloat MAX_HEIGHT = 250;
    CGSize size = [image size];
    if (size.width > MAX_WIDTH)
    {
        size.height = size.height * MAX_WIDTH / size.width;
        size.width = MAX_WIDTH;
    }
    if (size.height > MAX_HEIGHT)
    {
        size.width = size.width * MAX_HEIGHT / size.height;
        size.height = MAX_HEIGHT;
    }
        
    UIImage* scaledImage = [image scaleToSize:size];
    NSData* data = UIImageJPEGRepresentation(scaledImage, 0.9);
    self.registImageData = data;
    self.shopImage = scaledImage;
    NSLog(@"Photo selected");
    [self.view setNeedsDisplay];
    [picker dismissModalViewControllerAnimated:YES];
}
@end
