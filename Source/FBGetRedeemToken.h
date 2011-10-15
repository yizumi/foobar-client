//
//  FBGetRedeemToken.h
//  foobar
//
//  Created by 泉 雄介 on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBCommandBase.h"

@interface FBGetRedeemToken : FBCommandBase
{
}

@property (nonatomic, retain) NSString* deviceId;
@property (nonatomic, retain) NSNumber* shopKey;

@end
