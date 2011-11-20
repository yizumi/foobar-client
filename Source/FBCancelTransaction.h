//
//  FBCancelTransaction.h
//  foobar
//
//  Created by 泉 雄介 on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBCommandBase.h"


@interface FBCancelTransaction : FBCommandBase
{    
}

@property (nonatomic, retain) NSNumber* transactionKey;

@end
