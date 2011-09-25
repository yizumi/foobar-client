//
//  APCDate.h
//  foobar
//
//  Created by 泉 雄介 on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APCDateUtil : NSObject

+ (NSDateFormatter*) getJSONDateFormat;
+ (NSDate*) dateWithString:(NSString*) dateStr;

@end
