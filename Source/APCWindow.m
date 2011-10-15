//
//  APCWindow.m
//  foobar
//
//  Created by 泉 雄介 on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APCWindow.h"


@implementation APCWindow

+ (void) alert:(NSString*)message
{
    [APCWindow alert:message withTitle:@"エラー"];
}

+ (void) alert:(NSString*)message withTitle:(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

@end
