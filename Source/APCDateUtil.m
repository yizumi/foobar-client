//
//  APCDate.m
//  foobar
//
//  Created by 泉 雄介 on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCDateUtil.h"

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
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@""];
    NSDate* expirationDate = [[self getJSONDateFormat] dateFromString:dateStr];
    return expirationDate;
}

@end
