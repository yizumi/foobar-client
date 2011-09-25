//
//  ShowCodeViewModel.h
//  FooBar
//
//  Created by 泉 雄介 on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APCString.h"
#import "FBConfig.h"

@interface ShowCodeViewModel : NSObject {
}

@property (retain,nonatomic) NSNumber* mode;
@property (retain,nonatomic) NSString* tokenInput;
@property (retain,nonatomic) NSString* tokenDisplay;
@property (retain,nonatomic) NSString* instruction;
@property (retain,nonatomic) NSNumber* isTokenInputValid;

@property (retain,nonatomic) FBConfig* config;

- (void) toggleInputTokenChar:(char)chr;

@end
