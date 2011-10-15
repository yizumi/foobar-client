//
//  ShopViewController.h
//  foobar
//
//  Created by 泉 雄介 on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBShop.h"
#import "ShopViewCell.h"
#import "FBCommandBase.h"

@interface ShopViewController : UITableViewController
    <FBCommandBaseDelegate>
{
    NSManagedObject* _managedObject;
}

@property (nonatomic, retain) NSManagedObject* managedObject;

// ======================= Private Methods =======================
- (void) setImage:(NSNumber*) key on:(ShopViewCell*) cell;
- (void) showCodeViewWithToken:(NSString*)token;
- (void) getRedeemToken;
- (void) showRedeemTokenView:(NSString*)redeemToken withExpiration:(NSDate*)expiration;


@end
