//
//  StoreViewController.h
//  foobar
//
//  Created by 泉 雄介 on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBStore.h"
#import "StoreViewCell.h"

@interface StoreViewController : UITableViewController {
    NSManagedObject* _managedObject;
}

@property (nonatomic, retain) NSManagedObject* managedObject;

- (void) setImage:(NSString*) urlString on:(StoreViewCell*) cell;

// ======================= Private Methods =======================
- (void) showCodeViewWithToken:(NSString*)token;
- (void) getRedeemToken;
- (void) showRedeemTokenView:(NSString*)redeemToken withExpiration:(NSDate*)expiration;


@end
