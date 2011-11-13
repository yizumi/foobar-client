//
//  APCDate.m
//  foobar
//
//  Created by 泉 雄介 on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCDateUtil.h"

@implementation NSDate (APCDateUtil)

- (NSString*) toString:(NSString *)format
{
    if (format == nil) return nil;
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

@end

@implementation APCDateUtil

NSDateFormatter* JSON_DATEFORMAT;

+ (NSDateFormatter*) getJSONDateFormat
{
    if (JSON_DATEFORMAT == nil) {
        JSON_DATEFORMAT = [[NSDateFormatter alloc]init];
        [JSON_DATEFORMAT setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZZ"];
    }
    return JSON_DATEFORMAT;
}

+ (NSDate*) dateWithString:(NSString*)dateStr
{
    NSLog(@"I'm being called: %@", dateStr);
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@""];
    NSDate* expirationDate = [[self getJSONDateFormat] dateFromString:dateStr];
    return expirationDate;
}

@end
