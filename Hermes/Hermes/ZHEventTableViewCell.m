//
//  ZHEventTableViewCell.m
//  Hermes
//
//  Created by XuanXie on 1/21/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ZHEventTableViewCell.h"
#import "ZHUtility.h"

static const CGFloat ZHEventCellMargin1 = 10.0f;
static const CGFloat ZHEventCellMargin2 = 5.0f;
static const CGFloat ZHEventCellMargin3 = 7.5f;
static const CGFloat ZHEventImageSize = 60.0f;
static const CGFloat ZHEventTitleHeight = 20.0f;
static const CGFloat ZHEventTimeHeight = 10.0f;
static const CGFloat ZHEventOwnerWidth = 40.0f;
static const CGFloat ZHEventGroupWidth = 30.0f;

@interface ZHEventTableViewCell ()

@property (nonatomic, strong) UIImageView *eventImageView;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *ownerLabel;
@property (nonatomic, strong) UILabel *ownerNameLabel;
@property (nonatomic, strong) UILabel *groupLabel;
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, strong) ZHEvent *event;

@end

@implementation ZHEventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupImageView];
        [self setupTextLabel];
    }
    return self;
}

- (void)setupImageView {
    self.eventImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.eventImageView];
}

- (void)setupTextLabel {
    self.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [self.contentView addSubview:self.textLabel];
    
    self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.startTimeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    [self.contentView addSubview:self.startTimeLabel];
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.endTimeLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:10];
    [self.contentView addSubview:self.endTimeLabel];
    
    self.ownerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.ownerLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    self.ownerLabel.text = @"发起人：";
    [self.contentView addSubview:self.ownerLabel];
    
    self.ownerNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.ownerNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    [self.contentView addSubview:self.ownerNameLabel];
    
    self.groupLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.groupLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    self.groupLabel.text = @"小组：";
    [self.contentView addSubview:self.groupLabel];
    
    self.groupNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.groupNameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
    [self.contentView addSubview:self.groupNameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageViewTopPadding = ceil((CGRectGetHeight(self.bounds) - ZHEventImageSize) / 2);
    self.eventImageView.frame = CGRectMake(ZHEventCellMargin1, imageViewTopPadding, ZHEventImageSize, ZHEventImageSize);
    
    CGFloat textLabelLeftPadding = ZHEventCellMargin1 + ZHEventImageSize + ZHEventCellMargin1;
    CGFloat textLabelWidth = self.bounds.size.width - textLabelLeftPadding - ZHEventCellMargin2;
    self.textLabel.frame = CGRectMake(textLabelLeftPadding, ZHEventCellMargin2, textLabelWidth, ZHEventTitleHeight);
    
    CGFloat timeLabelTopPadding = ZHEventCellMargin2 + ZHEventTitleHeight + ZHEventCellMargin3;
    CGFloat timeLabelWidth = textLabelWidth / 2;
    self.startTimeLabel.frame = CGRectMake(textLabelLeftPadding, timeLabelTopPadding, timeLabelWidth, ZHEventTimeHeight);
    self.endTimeLabel.frame = CGRectMake(textLabelLeftPadding + timeLabelWidth, timeLabelTopPadding, timeLabelWidth, ZHEventTimeHeight);
    
    CGFloat ownerLabelTopPadding = timeLabelTopPadding + ZHEventTimeHeight + ZHEventCellMargin3;
    self.ownerLabel.frame = CGRectMake(textLabelLeftPadding, ownerLabelTopPadding, ZHEventOwnerWidth, ZHEventTimeHeight);
    self.ownerNameLabel.frame = CGRectMake(textLabelLeftPadding + ZHEventOwnerWidth, ownerLabelTopPadding, timeLabelWidth - ZHEventOwnerWidth, ZHEventTimeHeight);
    self.groupLabel.frame = CGRectMake(textLabelLeftPadding + timeLabelWidth, ownerLabelTopPadding, ZHEventGroupWidth, ZHEventTimeHeight);
    self.groupNameLabel.frame = CGRectMake(textLabelLeftPadding + timeLabelWidth + ZHEventGroupWidth, ownerLabelTopPadding, timeLabelWidth - ZHEventGroupWidth, ZHEventTimeHeight);
}

- (void)updateWithEvent:(ZHEvent *)event {
    self.event = event;
    
    self.textLabel.text = event.title;
    NSString *startTime = @"开始时间：";
    startTime = [startTime stringByAppendingString:[ZHUtility getStringFromDate:event.startTime]];
    self.startTimeLabel.text = startTime;
    NSString *endTime = @"结束时间：";
    endTime = [endTime stringByAppendingString:[ZHUtility getStringFromDate:event.endTime]];
    self.endTimeLabel.text = endTime;
    self.ownerNameLabel.text = event.ownerName;
    self.groupNameLabel.text = event.groupName;
    
    NSURL *iconUrl = [NSURL URLWithString:event.iconUrlSmall];
    NSURLRequest *request = [NSURLRequest requestWithURL:iconUrl];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak ZHEventTableViewCell *weakSelf = self;
    [self.eventImageView setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakSelf.eventImageView.image = image;
                                            [weakSelf setNeedsLayout];
                                        } failure:nil];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.textLabel.text = @"";
    self.eventImageView.image = nil;
    self.startTimeLabel.text = @"";
    self.endTimeLabel.text = @"";
    self.ownerNameLabel.text = @"";
    self.groupNameLabel.text = @"";
}

@end