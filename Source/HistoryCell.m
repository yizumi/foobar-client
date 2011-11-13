//
//  HistoryCell.m
//  foobar
//
//  Created by 泉 雄介 on 11/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryCell.h"
#import "APCDateUtil.h"
#import "FBConfig.h"
#import "APCColor.h"

@implementation HistoryCell
@synthesize dateLabel;
@synthesize addOrRedeemLabel;
@synthesize shopNameLabel;
@synthesize pointsLabel;

// ========================== private helpers ===========================

- (NSString*) getAddOrRedeemText:(TransactionInfo*) trans
{
    // Detect case when the user is on the shop-side of the transaction
    long shopKey = [[FBConfig sharedInstance] shopKey];
    if (shopKey == [trans.shopKey longValue])
    {
        // Points Issued
        if ([trans.addOrRedeem isEqual:@"Add"])
            return NSLocalizedString(@"HistoryCell_IssuedPoints",@"");
        return NSLocalizedString(@"HistoryCell_RedeemedPoints",@"");
    }
    
    if ([trans.addOrRedeem isEqual:@"Add"])
        return NSLocalizedString(@"HistoryCell_ReceivedPoints",@"");
    return NSLocalizedString(@"HistoryCell_UsedPoints",@"");
}

// Returns
- (UIColor*) getColor:(TransactionInfo*) trans
{
    long shopKey = [[FBConfig sharedInstance] shopKey];
    if (shopKey == [trans.shopKey longValue])
    {
        // Points Issued
        if ([trans.addOrRedeem isEqual:@"Add"])
            return [APCColor colorWithHex:@"000099"];
        return [APCColor colorWithHex:@"FF6600"];
    }
    
    if ([trans.addOrRedeem isEqual:@"Add"])
        return [APCColor colorWithHex:@"339900"];
    return [APCColor colorWithHex:@"CC0000"];
}

// ========================== public helpers ===========================

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [dateLabel release];
    [addOrRedeemLabel release];
    [shopNameLabel release];
    [pointsLabel release];
    [super dealloc];
}

- (void)bind:(TransactionInfo *)trans
{
    NSString* dateFormat = NSLocalizedString(@"HistoryCell_DateFormat", @"");
    dateLabel.text = [trans.time toString:dateFormat];
    shopNameLabel.text = trans.shopName;
    addOrRedeemLabel.text = [self getAddOrRedeemText:trans];
    pointsLabel.text = [NSString stringWithFormat:@"%@ Pt.", trans.points];
    [pointsLabel setTextColor:[self getColor:trans]];
        
    CGRect frame = dateLabel.frame;
    CGSize size = [dateLabel.text sizeWithFont:dateLabel.font];
    frame.size.width = size.width;
    dateLabel.frame = frame;
    
    CGRect frame2 = addOrRedeemLabel.frame;
    frame2.origin.x = frame.origin.x + frame.size.width + 2;
    addOrRedeemLabel.frame = frame2;
    [addOrRedeemLabel setTextColor:[self getColor:trans]];
}


@end
