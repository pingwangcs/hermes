//
//  ZHPhotoAlbumCollectionViewCell.m
//  Hermes
//
//  Created by XuanXie on 1/27/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHPhotoAlbumCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZHUtility.h"

static const CGFloat ZHPhotoAlbumCellMargin = 10.0f;
static const CGFloat ZHPhotoAlbumCoverImageSize = 100.0f;


@interface ZHPhotoAlbumCollectionViewCell ()

@property (nonatomic, strong) UIImageView *photoAlbumImageView;
@property (nonatomic, strong) UILabel *photoAlbumTitleLabel;
@property (nonatomic, strong) ZHPhotoAlbum *photoAlbum;

@end


@implementation ZHPhotoAlbumCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 3.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowOpacity = 0.5f;
        
        [self setupImageView];
        [self setupTextLabel];
    }
    
    return self;
}

- (void)setupImageView
{
    self.photoAlbumImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.photoAlbumImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoAlbumImageView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.photoAlbumImageView];
}

- (void)setupTextLabel
{
    self.photoAlbumTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.photoAlbumTitleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    [self.contentView addSubview:self.photoAlbumTitleLabel];
}

- (void)updateWithPhotoAlbum:(ZHPhotoAlbum *)photoAlbum
{
    self.photoAlbum = photoAlbum;
    
    self.photoAlbumTitleLabel.text = photoAlbum.title;
    
    NSString *strUrl = [photoAlbum.cover stringByReplacingOccurrencesOfString:@"medium" withString:@"large"];
    NSURL *coverUrl = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:coverUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak ZHPhotoAlbumCollectionViewCell *weakSelf = self;
    [self.photoAlbumImageView setImageWithURLRequest:request
                                    placeholderImage:placeholderImage
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakSelf.photoAlbumImageView.image = image;
                                            [weakSelf setNeedsLayout];
                                        } failure:nil];
}

@end
