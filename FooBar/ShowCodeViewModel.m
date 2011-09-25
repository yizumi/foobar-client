//
//  ShowCodeViewModel.m
//  FooBar
//
//  Created by 泉 雄介 on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowCodeViewModel.h"


@implementation ShowCodeViewModel

@synthesize mode, tokenDisplay, tokenInput, instruction, isTokenInputValid, config;

- (ShowCodeViewModel*) init
{
    self = [super init];
    if( self == nil )
        return nil;
    
    // initial values.
    self.tokenInput = @"";
    self.tokenDisplay = @"";
    self.mode = 0;
    self.instruction = @"Show Code to Salesperson";
    self.config = [FBConfig sharedInstance];
    
    [self addObserver:self 
           forKeyPath:@"mode" 
              options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
              context:nil];
    
    [self addObserver:self 
           forKeyPath:@"tokenInput" 
              options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
              context:nil];
    
    [config addObserver:self 
             forKeyPath:@"userLoginToken" 
                options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                context:nil];
        
    return self;
}

- (void) dealloc
{
    [tokenInput release];
    [tokenDisplay release];
    [mode release];
    [instruction release];
    [isTokenInputValid release];
    [config removeObserver:self forKeyPath:@"userLoginToken"];
    [config release];
    [super dealloc];
}

// If the character doesn't exist, it adds the character to the inputToken.
// If the character already exists, the character will be removed from the inputToken.
// The view model restricts the change to the display token if 
- (void) toggleInputTokenChar:(char)chr
{
    int index = [tokenDisplay indexOf:chr]; 
    if (index > -1 )
    {
        NSString* newStr = [NSString stringWithFormat:@"%@%@",
                            [tokenDisplay substringToIndex:index],
                             [tokenDisplay substringFromIndex:index+1]];
        [self setValue:[newStr sort] forKey:@"tokenInput"];
    }
    else
    {
        NSString* newStr = [NSString stringWithFormat:@"%@%c", tokenDisplay, chr];
        [self setValue:[newStr sort] forKey:@"tokenInput"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if( [keyPath isEqual:@"mode"] )
    {
        switch([mode intValue])
        {
            case 0:
                [self setValue:@"Present Code to Salesperson" forKey:@"instruction"];
                [self setValue:[FBConfig sharedInstance].userLoginToken forKey:@"tokenDisplay"];
                break;
            case 1:
                [self setValue:@"Enter Code" forKey:@"instruction"];
                [self setValue:tokenInput forKey:@"tokenDisplay"];
                break;
        }
    }
    
    if( [keyPath isEqual:@"tokenInput"] )
    {
        NSString* newTokenInput = (NSString*)[change objectForKey:NSKeyValueChangeNewKey];
        if( [mode intValue] == 1 )
        {
            if ( [newTokenInput length] >= 5)
            {
                [self setValue:@"Click Here to Set Points" forKey:@"instruction"];
                [self setValue:[NSNumber numberWithBool:YES] forKey:@"isTokenInputValid"];
            }
            else
            {
                [self setValue:@"Enter Code" forKey:@"instruction"];
                [self setValue:[NSNumber numberWithBool:NO] forKey:@"isTokenInputValid"];
            }
        }
    }
    
    // Remember! It's all about ViewModel here baby!
    if ( [keyPath isEqual:@"userLoginToken"] )
    {
        NSString* newUserLoginToken = (NSString*)[change objectForKey:NSKeyValueChangeNewKey];
        if( [mode intValue] == 0)
        {
            [self setValue:newUserLoginToken forKey:@"tokenDisplay"];
        }
    }
}

@end
