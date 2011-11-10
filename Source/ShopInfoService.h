//
//  FBShopManager.h
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopInfo.h"
#import "APCDataModelService.h"

@interface ShopInfoService : APCDataModelService
{
}

+ (ShopInfoService *) sharedInstance;
- (id) init;
- (void) updateShopRedeemToken:(NSString*)token 
                  andExpiration:(NSDate*)expDate 
                       forShop:(NSNumber*)shopKey;
- (NSFetchedResultsController*) fetchAll;

@end
