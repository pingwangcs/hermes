//
//  ZHEventDetailsViewController.m
//  Hermes
//
//  Created by XuanXie on 1/26/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHEventDetailsViewController.h"

@interface ZHEventDetailsViewController ()

@property (nonatomic, strong) UIWebView *eventWebView;
@property (nonatomic, strong) ZHEvent *event;

@end

@implementation ZHEventDetailsViewController

- (id)initWithEvent:(ZHEvent *)event
{
    self = [super init];
    
    if (self)
    {
        self.event = event;
        [self setupWebView];
    }
    
    return self;
}

- (void)setupWebView
{
    self.eventWebView = [[UIWebView alloc] init];
    NSURL *url = [NSURL URLWithString:self.event.url];
    [self.eventWebView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    self.view = self.eventWebView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end