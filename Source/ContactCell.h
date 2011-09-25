//
//  ContactCell.h
//  foobar
//
//  Created by 泉 雄介 on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContactCell : UITableViewCell {
    
}

@property (retain,nonatomic) IBOutlet UILabel* labelType;
@property (retain,nonatomic) IBOutlet UILabel* labelInfo;
@property (retain,nonatomic) IBOutlet UILabel* labelAction;

@end
