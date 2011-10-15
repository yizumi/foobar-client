//
//  ShopLoginViewController.h
//  foobar
//
//  Created by 泉 雄介 on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBCommandBase.h"
#import "TextFormCell.h"

@class ShopLoginViewController;

@protocol ShopLoginViewControllerDelegate <NSObject>

- (void) didLogin:(ShopLoginViewController*)ctrl;
- (void) createdShop:(ShopLoginViewController*)ctrl;
- (void) didCancel:(ShopLoginViewController*)ctrl;

@end

@interface ShopLoginViewController : UITableViewController <
    UITextFieldDelegate,
    FBCommandBaseDelegate,
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate>
{
    id <ShopLoginViewControllerDelegate> delegate;
    
    int _cameraButtonIndex;
    int _photoLibButtonIndex;
    int _photoAlbumButtonIndex;
}

@property (nonatomic, retain) NSString* loginEmail;
@property (nonatomic, retain) NSString* loginPassword;
@property (nonatomic, retain) NSString* registName;
@property (nonatomic, retain) NSString* registAddress;
@property (nonatomic, retain) NSString* registTel;
@property (nonatomic, retain) NSString* registUrl;
@property (nonatomic, retain) NSString* registEmail;
@property (nonatomic, retain) NSString* registPassword;
@property (nonatomic, retain) NSData* registImageData;
@property (nonatomic, retain) UIImage* shopImage;

@property (nonatomic, assign) id <ShopLoginViewControllerDelegate> delegate;

@end