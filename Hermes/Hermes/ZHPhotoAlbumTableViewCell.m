//
//  ZHPhotoAlbumCollectionViewCell.m
//  Hermes
//
//  Created by XuanXie on 1/27/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ZHPhotoAlbumTableViewCell.h"
#import "ZHUtility.h"

static const CGFloat ZHPhotoAlbumCellMargin = 10.0f;
static const CGFloat ZHPhotoAlbumImageSize = 100.0f;
static const CGFloat ZHPhotoAlbumTitleHeight = 50.0f;

@interface ZHPhotoAlbumTableViewCell ()

@property (nonatomic, strong) UIImageView *photoAlbumImageView;
@property (nonatomic, strong) UILabel *photoAlbumTitleLabel;
@property (nonatomic, strong) ZHPhotoAlbum *photoAlbum;

@end

@implementation ZHPhotoAlbumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupImageView];
        [self setupTextLabel];
    }
    return self;
}

- (void)setupImageView {
    self.photoAlbumImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.photoAlbumImageView];
}

- (void)setupTextLabel {
    self.photoAlbumTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.photoAlbumTitleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    self.photoAlbumTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.photoAlbumTitleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageViewTopPadding = ceil((CGRectGetHeight(self.bounds) - ZHPhotoAlbumImageSize) / 2);
    self.photoAlbumImageView.frame = CGRectMake(ZHPhotoAlbumCellMargin, imageViewTopPadding, ZHPhotoAlbumImageSize, ZHPhotoAlbumImageSize);
    
    CGFloat textLabelLeftPadding = ZHPhotoAlbumCellMargin + ZHPhotoAlbumImageSize + ZHPhotoAlbumCellMargin;
    CGFloat textLabelWidth = self.bounds.size.width - textLabelLeftPadding - ZHPhotoAlbumCellMargin;
    self.photoAlbumTitleLabel.frame = CGRectMake(textLabelLeftPadding, imageViewTopPadding, textLabelWidth, ZHPhotoAlbumTitleHeight);
}

- (void)updateWithPhotoAlbum:(ZHPhotoAlbum *)photoAlbum {
    self.photoAlbum = photoAlbum;

    self.photoAlbumTitleLabel.text = photoAlbum.title;

    NSURL *coverUrl = [NSURL URLWithString:photoAlbum.cover];
    NSURLRequest *request = [NSURLRequest requestWithURL:coverUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak ZHPhotoAlbumTableViewCell *weakSelf = self;
    [self.photoAlbumImageView setImageWithURLRequest:request
                                    placeholderImage:placeholderImage
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 weakSelf.photoAlbumImageView.image = image;
                                                 [weakSelf setNeedsLayout];
                                             } failure:nil];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.photoAlbumImageView.image = nil;
    self.photoAlbumTitleLabel.text = @"";
}

@end
