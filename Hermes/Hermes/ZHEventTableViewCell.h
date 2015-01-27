//
//  ZHEventTableViewCell.h
//  Hermes
//
//  Created by XuanXie on 1/21/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHEvent.h"


@interface ZHEventTableViewCell : UITableViewCell

- (void)updateWithEvent:(ZHEvent *)event;

@end

