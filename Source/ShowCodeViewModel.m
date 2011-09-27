//
//  ShowCodeViewModel.m
//  FooBar
//
//  Created by 泉 雄介 on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowCodeViewModel.h"

@implementation ShowCodeViewModel

@synthesize mode;
@synthesize tokenDisplay;
@synthesize tokenInput;
@synthesize instruction;
@synthesize isTokenInputValid;
@synthesize config;
@synthesize expirationDate;

- (ShowCodeViewModel*) init
{
    self = [super init];
    if( self == nil )
        return nil;
    
    // initial values.
    self.tokenInput = @"";
    self.tokenDisplay = @"";
    self.mode = K_MODE_TAKE;
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
    NSLog(@"ViewModel is being dealloc'ed");
    
    // Remove 
    [config removeObserver:self forKeyPath:@"userLoginToken"];
    [self removeObserver:self forKeyPath:@"mode"];
    [self removeObserver:self forKeyPath:@"tokenInput"];
    
    [tokenInput release];
    [tokenDisplay release];
    [mode release];
    [instruction release];
    [isTokenInputValid release];
    [config release];
    _timer = nil;
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
        // [self setValue:[newStr sort] forKey:@"tokenInput"];
        [self setValue:newStr forKey:@"tokenInput"];
    }
    else
    {
        NSString* newStr = [NSString stringWithFormat:@"%@%c", tokenDisplay, chr];
        // [self setValue:[newStr sort] forKey:@"tokenInput"];
        [self setValue:newStr forKey:@"tokenInput"];
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
            case 2:
                [self setValue:@"Present Code to Salesperson" forKey:@"instruction"];
                [self beginExpirationTimer];
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
        if( [mode intValue] == K_MODE_TAKE)
        {
            [self setValue:newUserLoginToken forKey:@"tokenDisplay"];
        }
    }
}

- (void) beginExpirationTimer
{
    NSLog(@"Beginning the timer");
    // Should only be activated for MODE=3
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(checkExpiration:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void) checkExpiration:(NSTimer*)timer
{
    NSLog(@"Timer working...");
}

- (void) stopExpirationTimer
{
    if (_timer && [_timer isValid])
    {
        NSLog(@"Stopping the timer");
        [_timer invalidate];
    }
    else
    {
        NSLog(@"Timer is not active");
    }
}

@end
