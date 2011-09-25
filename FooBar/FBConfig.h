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

@property (retain,nonatomic) NSString* userLoginId;
@property (retain,nonatomic) NSString* userLoginToken;
@property (retain,nonatomic) NSString* storeLoginId;
@property (retain,nonatomic) NSString* storeLoginToken;
@property (retain,nonatomic) NSDate* tokenExpireDate;

+ (FBConfig *) sharedInstance;
- (FBConfig *) init;

@end
