//
//  ShopInfoService.m
//  FooBar
//
//  Created by 泉 雄介 on 11/07/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopInfoService.h"
#import "SBJson.h"
#import "APCDateUtil.h"

@implementation ShopInfoService

static ShopInfoService *_sharedInstance = nil;

+ (ShopInfoService *) sharedInstance
{
    if( !_sharedInstance )
    {
        _sharedInstance = [[ShopInfoService alloc] init];
    }
    return _sharedInstance;
}

- (id) init
{
    self = [super initWithTableName:@"ShopInfo"];
    if (self != nil)
    {
        
    }
    return self;
}


- (void) updateShopRedeemToken:(NSString*)token 
                 andExpiration:(NSDate*)expDate 
                       forShop:(NSNumber*)shopKey
{
    ShopInfo* shop = (ShopInfo*)[self getByKey:shopKey];
    if (shop == nil )
    {
        NSLog(@"Error: Could not find shop by identifier: %@", shopKey);
        return;
    }
    
    shop.redeemToken = token;
    shop.redeemTokenExpiration = expDate;
    
    [self commit];
    NSLog(@"Saved redemption code for %@", shopKey);
}

- (void) updateRemainingPoints:(NSNumber*)points
                       forShop:(NSNumber*)shopKey
{
    ShopInfo* shop = (ShopInfo*)[self getByKey:shopKey];
    if (shop == nil)
    {
        NSLog(@"Error: Could not find shop by identifier: %@", shopKey);
        return;
    }
    
    shop.points = points;
    
    [self commit];
    NSLog(@"Saved remaining points for ShopInfo(%@", shopKey);
}

- (void)buildDataModel:(APCDataModel *)model from:(NSDictionary *)obj
{
    ShopInfo* shop = (ShopInfo*)model;
    
    shop.name = (NSString*)[obj valueForKey:@"name"];
    shop.address = (NSString*)[obj valueForKey:@"address"];
    shop.url = (NSString*)[obj valueForKey:@"url"];
    shop.firstVisit = [APCDateUtil dateWithString:(NSString*)[obj valueForKey:@"firstVisit"]];
    shop.lastVisit = [APCDateUtil dateWithString:(NSString*)[obj valueForKey:@"lastVisit"]];
    shop.points = (NSNumber*)[obj valueForKey:@"points"];
    shop.tel = (NSString*)[obj valueForKey:@"tel"];
    shop.imageUrl = (NSString*)[obj valueForKey:@"imageUrl"];
    shop.sectionTitle = [shop.name substringToIndex:1];
}

- (NSFetchedResultsController*) fetchAll
{
    return [self fetchAllSortBy:@"name"
                      ascending:YES
               withSectionTitle:@"sectionTitle"];
}

@end
