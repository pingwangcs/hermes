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

- (id)initWithEvent:(ZHEvent *)event {
    self = [super init];
    
    if (self) {
        self.event = event;
        [self setTitle:self.event.title];
        [self setupWebView];
    }
    return self;
}

- (void)setupWebView {
    self.eventWebView = [[UIWebView alloc] init];
    
    NSURL *url = [NSURL URLWithString:self.event.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [self addCookies:cookies forRequest:request];

    [self.eventWebView loadRequest:request];
    self.view = self.eventWebView;
}

- (void)addCookies:(NSArray *)cookies forRequest:(NSMutableURLRequest *)request {
    NSString *cookieHeader = [NSString stringWithFormat: @"%@=%@", @"51zhaohu_app", @"true"];

    if ([cookies count] > 0) {
        for (NSHTTPCookie *cookie in cookies) {
            cookieHeader = [NSString stringWithFormat: @"%@; %@=%@",cookieHeader,[cookie name],[cookie value]];
        }
    }

    if (cookieHeader) {
        [request setValue:cookieHeader forHTTPHeaderField:@"Cookie"];
    }
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