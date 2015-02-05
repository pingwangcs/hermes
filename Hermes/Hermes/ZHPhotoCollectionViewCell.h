//
//  ZHPhotoCollectionViewCell.h
//  Hermes
//
//  Created by XuanXie on 1/28/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPhoto.h"

@interface ZHPhotoCollectionViewCell : UICollectionViewCell

- (void)updateWithPhoto:(ZHPhoto *)photo;

@end