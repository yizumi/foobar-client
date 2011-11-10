//
//  TransactionInfoExt.m
//  foobar
//
//  Created by 泉 雄介 on 11/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TransactionInfoExt.h"


@implementation TransactionInfo (TransactionInfoExt)

- (NSString*) yearMonth
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM"];
    NSString* tmp = [formatter stringFromDate:self.time];
    return tmp;
}

@end
