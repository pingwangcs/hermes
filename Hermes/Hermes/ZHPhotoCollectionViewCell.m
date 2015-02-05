//
//  ZHPhotoCollectionViewCell.m
//  Hermes
//
//  Created by XuanXie on 1/28/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ZHPhotoCollectionViewCell.h"
#import "ZHUtility.h"

static const CGFloat ZHPhotoImageSize = 100.0f;

@interface ZHPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) ZHPhoto *photo;

@end

@implementation ZHPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView {
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZHPhotoImageSize, ZHPhotoImageSize)];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.photoImageView];
}

- (void)updateWithPhoto:(ZHPhoto *)photo {
    self.photo = photo;

    NSURL *thumbnailUrl = [NSURL URLWithString:photo.thumbnailLarge];
    NSURLRequest *request = [NSURLRequest requestWithURL:thumbnailUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak ZHPhotoCollectionViewCell *weakSelf = self;
    [self.photoImageView setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakSelf.photoImageView.image = image;
                                            [weakSelf setNeedsLayout];
                                        } failure:nil];
}

@end

