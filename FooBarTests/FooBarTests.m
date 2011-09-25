//
//  FooBarTests.m
//  FooBarTests
//
//  Created by 泉 雄介 on 11/07/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FooBarTests.h"


@implementation FooBarTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in FooBarTests");
}

- (void)testStoreInfoManager
{
    StoreInfoManager* mgr = [StoreInfoManager sharedInstance];
    NSDictionary* dict = [NSDictionary alloc];
    [dict setValue:@"東京都港区南麻布３−１９−２５" forKey:@"address"];
    [dict setValue:@"まんじまけろーに" forKey:@"name"];
    [dict setValue:@"http://www.manjimakeroni.jp" forKey:@"url"];
    [dict setValue:@"41268108" forKey:@"identifier"];
    [dict setValue:[NSNumber numberWithInt:25] forKey:@"points"];
    /*
    @property (nonatomic, retain) NSString * address;
    @property (nonatomic, retain) NSString * name;
    @property (nonatomic, retain) NSString * url;
    @property (nonatomic, retain) NSString * identifier;
    @property (nonatomic, retain) NSDate * firstVisit;
    @property (nonatomic, retain) NSDate * lastVisit;
    @property (nonatomic, retain) NSNumber * points;
    */
    [mgr updateWithDictionary:dict];
    StoreInfo* store = [[mgr getByIdentifier:@"41268108"]autorelease];
    STAssertNotNil(store, @"getByIdetnfier failed");
    
    [dict release];
}

@end
