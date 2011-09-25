//
//  FBConfig.h
//  FooBar
//
//  Created by 泉 雄介 on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBConfig : NSObject {    
}

extern NSString* const K_URL_REGISTER_DEVICE_TOKEN;
extern NSString* const K_URL_GIVE_OR_REDEEM_POINTS;
extern NSString* const K_URL_GET_STORE_LIST_FOR_DEVICE;
extern NSString* const K_URL_LOGIN_STORE;
extern NSString* const K_URL_REGISTER_STORE;
extern NSString* const K_URL_GET_REDEEM_TOKEN;
extern NSString* const K_URL_MAP;

@property (retain,nonatomic) NSString* userLoginId;
@property (retain,nonatomic) NSString* userLoginToken;
@property (retain,nonatomic) NSString* storeLoginId;
@property (retain,nonatomic) NSString* storeLoginToken;
@property (retain,nonatomic) NSDate* tokenExpireDate;
@property (retain,nonatomic) NSString* deviceId;

+ (FBConfig *) sharedInstance;
- (FBConfig *) init;

@end
