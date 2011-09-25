//
//  FooBarTests.m
//  FooBarTests
//
//  Created by 泉 雄介 on 11/07/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FooBarTests.h"

#import "FBStoreManager.h"
#import "FBStore.h"
#import "APCDateUtil.h"
#import "ASIHTTPRequest.h"
#import "NSObject+SBJson.h"

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
    // STFail(@"Unit tests are not implemented yet in FooBarTests");
}

- (void)testFBStoreManager
{
    FBStoreManager* mgr = [FBStoreManager sharedInstance];
    NSDictionary* dict = [[[NSDictionary alloc]initWithObjectsAndKeys:
                           @"41268108", @"identifier",
                           @"まんじまけろーに", @"name",
                           @"東京都港区南麻布３−１９−２５", @"address",
                           @"http://www.manjimakeroni.jp", @"url",
                           @"03-5423-0000", @"tel",
                           [APCDateUtil dateWithString:@"2011-01-01 10:00:00 AM"], @"firstVisit",
                           [APCDateUtil dateWithString:@"2011-07-01 06:00:00 PM"], @"lastVisit",
                           [NSNumber numberWithInt:25], @"points",
                           nil] autorelease];
    
    [mgr updateWithDictionary:dict];
    FBStore* store = [[mgr getByIdentifier:@"41268108"]autorelease];
    STAssertNotNil(store, @"getByIdetnfier failed");
    NSLog(@"Store Name: %@", store.name);
    STAssertEquals(store.name, @"まんじまけろーに", @"name");
    STAssertEquals(store.address, @"東京都港区南麻布３−１９−２５", @"address");
    STAssertEquals(store.url, @"http://www.manjimakeroni.jp", @"url");
    STAssertEquals(store.tel, @"03-5423-0000", @"tel");
    STAssertEquals(store.firstVisit, [APCDateUtil dateWithString:@"2011-01-01 10:00:00 AM"], @"firstVisit");
    STAssertEquals(store.lastVisit, [APCDateUtil dateWithString:@"2011-08-01 06:00:00 AM"], @"lastVisit");
}

- (void)testFBStoreManagerUpdateWithList
{
    FBStoreManager * mgr = [FBStoreManager sharedInstance];
    NSURL* url = [NSURL URLWithString:@"http://localhost:8080/getStoreListForDevice.php"];
    ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:url];
    [req startSynchronous];
    if( [req error] != nil )
    {
        NSError* error = [req error];
        STFail(@"Error: %@", error);
        return;
    }
    
    NSArray* array = [[req responseString] JSONValue];
    [mgr updateWithList:array];
    FBStore* store = [mgr getByIdentifier:@"41268109"];
    NSLog(@"Name:%@", store.name);
    NSLog(@"Ariran Korean Dining");
    STAssertEquals(store.name, @"Ariran Korean Dining", @"name");
}

- (void) testDateParse
{
    NSString* dateStr = @"2011-12-31T12:34:56+0900";
    NSDate* expirationDate = [APCDateUtil dateWithString:dateStr];
    
    // show date
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSLog(@"User's current time in their preference format: %@",
          [dateFormatter stringFromDate:expirationDate]);
}

- (void) testSQL
{
    // todo: getting the initial characters from the FBStoreManager [DONE]
    
    // todo: display the store details in the disclosure panel [DONE]
    
    // todo: display the redeem matrix
    
    // todo: getting the coupon list loaded
    
    // todo: display the coupon details in the disclosure panel
    
    // todo: add store icon
    
    // todo: adding store pictures in the disclosure panel [DONE]
    
    // todo: add foobar icon [DONE]
    
    // todo: program the back-end
    
    // todo: change the urls
    
    // todo: test, release!
}

@end

