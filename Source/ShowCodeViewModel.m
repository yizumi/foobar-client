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
@synthesize expirationDate;
@synthesize remainingTimeInSec;
@synthesize timer;
@synthesize shopKey;

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
    
    [self addObserver:self 
           forKeyPath:@"mode" 
              options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
              context:nil];
    
    [self addObserver:self 
           forKeyPath:@"tokenInput" 
              options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
              context:nil];

    NSUserDefaults* konfig = [NSUserDefaults standardUserDefaults];
    [konfig addObserver:self 
             forKeyPath:K_DEFAULTS_USER_TOKEN
                options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                context:nil];
    
    return self;
}

- (void) dealloc
{
    NSLog(@"ViewModel is being dealloc'ed");
    
    [self removeObserver:self forKeyPath:@"mode"];
    [self removeObserver:self forKeyPath:@"tokenInput"];
    
    NSUserDefaults* konfig = [NSUserDefaults standardUserDefaults];
    [konfig removeObserver:self forKeyPath:K_DEFAULTS_USER_TOKEN];

    [tokenInput release];
    [tokenDisplay release];
    [mode release];
    [instruction release];
    [isTokenInputValid release];
    [shopKey release];
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
                [self setValue:[[FBConfig sharedInstance] userToken] forKey:@"tokenDisplay"];
                break;
            case 1:
                [self setValue:@"Enter Code" forKey:@"instruction"];
                [self setValue:tokenInput forKey:@"tokenDisplay"];
                break;
            case 2:
                [self setValue:@"Present Code to Salesperson" forKey:@"instruction"];
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


// ======================================== TIMER STUFF =====================================
- (void) beginExpirationTimer
{
    if ([mode intValue] != K_MODE_REDEEM)
    {
        NSLog(@"Invalid mode for timer");
        return;
    }
    
    if (timer != nil && [timer isValid])
    {
        NSLog(@"Timer already active");
        return;
    }
    NSLog(@"Beginning the timer");
    // Should only be activated for MODE=3
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(refreshExpiration:)
                                            userInfo:nil
                                             repeats:YES];
    // Since it takes 1 second for checkExpiration to be called, let's call refreshExpiration immediately
    [self refreshExpiration:nil];
}

- (void) refreshExpiration:(NSTimer*)timer
{
    // This is where we want to update the remaining time
    NSLog(@"Timer working...");
    NSNumber* remTimeInSec = [NSNumber numberWithDouble:[expirationDate timeIntervalSinceNow]];
    [self setValue:remTimeInSec forKey:@"remainingTimeInSec"];
}

- (void) stopExpirationTimer
{
    if (timer != nil && [timer isValid])
    {
        NSLog(@"Stopping the timer");
        [timer invalidate];
        timer = nil;
    }
    else
    {
        NSLog(@"Timer is not active");
    }
}

@end
