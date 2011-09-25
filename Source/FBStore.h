//
//  FBStore.h
//  foobar
//
//  Created by 泉 雄介 on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FBStore : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * firstVisit;
@property (nonatomic, retain) NSDate * lastVisit;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * redeemToken;
@property (nonatomic, retain) NSDate * redeemTokenExpiration;

@end
