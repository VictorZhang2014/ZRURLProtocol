# ZRURLProtocol
ZRURLProtocol is encapsulated of NSURLProtocol which can intercept all request in UIWebView

## Purpose
<< 1. To intercept all request in UIWebView 
<< 2. Want to mock NSURLRequest while requesting in UIWebView
<< 3. Want to replace some of images in HTML page request by local images

#### Apple Official Demo and Documentation
https://developer.apple.com/library/content/samplecode/CustomHTTPProtocol/Introduction/Intro.html

## Usage
1. In `AppDelegate.h` file
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ZRURLProtocol start];
    
    return YES;
}
```

2. Implement two methods in the `ZRURLProtocolDelegate` 
```
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
```

For more details , see 
- [NSURLProtocol Tutorial](https://www.raywenderlich.com/59982/nsurlprotocol-tutorial) 
- [NSURLProtocol Tutorial](http://draveness.me/intercept/) 


