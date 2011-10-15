//
//  FBRedeemPoints.h
//  foobar
//
//  Created by 泉 雄介 on 10/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBCommandBase.h"

@interface FBRedeemPoints : FBCommandBase
{    
}

@property (nonatomic, retain) NSNumber* shopKey;
@property (nonatomic, retain) NSString* redeemToken;
@property (nonatomic, retain) NSNumber* points;

@end
