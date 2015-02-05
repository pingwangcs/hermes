//
//  ZHPhotoDetailsViewController.m
//  Hermes
//
//  Created by XuanXie on 2/4/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ZHPhotoDetailsViewController.h"

@interface ZHPhotoDetailsViewController ()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) ZHPhoto *photo;

@end

@implementation ZHPhotoDetailsViewController

- (id)initWithPhoto:(ZHPhoto *)photo {
    self = [super init];
    
    if (self) {
        self.photo = photo;
        [self setTitle:self.photo.title];
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView {
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoImageView.frame = [[UIScreen mainScreen] applicationFrame];
    
    NSURL *photoUrl = [NSURL URLWithString:self.photo.thumbnailMaster];
    NSURLRequest *request = [NSURLRequest requestWithURL:photoUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
     __weak ZHPhotoDetailsViewController *weakSelf = self;
    [self.photoImageView setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakSelf.photoImageView.image = image;
                                        } failure:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view = self.photoImageView;
    self.view.contentMode = UIViewContentModeCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end