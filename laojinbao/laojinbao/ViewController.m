//
//  ViewController.m
//  laojinbao
//
//  Created by dusheng.xu on 25/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *loadFailedView;
@property (weak, nonatomic) IBOutlet UILabel *failedDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reloadButton.layer.cornerRadius = 3;
    self.reloadButton.layer.masksToBounds = YES;
    self.reloadButton.layer.borderColor = [UIColor colorWithRed:102.f/255.f green:102.f/255.f blue:102.f/255.f alpha:1].CGColor;
    self.reloadButton.layer.borderWidth = 0.7f;
    
    NSURL *url = [NSURL URLWithString:@"http://www.yajinbao.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (IBAction)reloadButtonClick:(id)sender {
    [self.webView reload];
}

//TODO: UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.loadFailedView.hidden = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (!webView.isLoading) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    if (error && !webView.isLoading) {
        self.loadFailedView.hidden = NO;
        [self handleError:error];
    }
}


- (void)handleError:(NSError *)error{
    NSString *errorMessage = @"啊哦…请求出错啦";
    if (([error.domain isEqualToString:@"WebKitErrorDomain"] && 101 == error.code) ||
        ([error.domain isEqualToString:NSURLErrorDomain] && (NSURLErrorBadURL == error.code || NSURLErrorUnsupportedURL == error.code))) {
    }else if ([error.domain isEqualToString:NSURLErrorDomain] && (NSURLErrorTimedOut == error.code ||
                                                                  NSURLErrorCannotFindHost == error.code ||
                                                                  NSURLErrorCannotConnectToHost == error.code ||
                                                                  NSURLErrorNetworkConnectionLost == error.code ||
                                                                  NSURLErrorDNSLookupFailed == error.code ||
                                                                  NSURLErrorNotConnectedToInternet == error.code)) {
        if (NSURLErrorTimedOut == error.code) {
            errorMessage = @"网络请求超时…";
        }
    }
    self.failedDescLabel.text = errorMessage;
    
}
@end
