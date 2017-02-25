//
//  ViewController.m
//  ZRURLProtocol
//
//  Created by VictorZhang on 25/02/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "ViewController.h"
#import "ZRURLProtocol.h"

@interface ViewController ()<ZRURLProtocolDelegate>

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURLRequest * req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:req];
    
    [ZRURLProtocol setDelegate:self];
    
}

- (void)URLProtocolEveryURLRequestInWebView:(NSURLRequest *)request
{
    //Every URL of the request will be invoked here.
    NSLog(@"url=%@", request.URL.absoluteString);
}

- (NSURLRequest *)URLProtocolOriginalRequest:(NSURLRequest *)request
{
    //1.Returns an new instance of NSURLRequest
    //2.Modifies the property of @param-request, like header's value or add new header property
    return request;
}


@end
