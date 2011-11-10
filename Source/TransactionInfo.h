//
//  TransactionInfo.h
//  foobar
//
//  Created by 泉 雄介 on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "APCDataModel.h"


@interface TransactionInfo : APCDataModel {
@private
}
@property (nonatomic, retain) NSNumber * shopKey;
@property (nonatomic, retain) NSString * shopName;
@property (nonatomic, retain) NSNumber * userKey;
@property (nonatomic, retain) NSString * searchKey;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * addOrRedeem;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * shopMessage;
@property (nonatomic, retain) NSString * userName;

@end
