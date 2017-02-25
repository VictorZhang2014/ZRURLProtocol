//
//  ZRURLProtocol.m
//  ZRURLProtocol
//
//  Created by VictorZhang on 25/02/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

#import "ZRURLProtocol.h"

#define protocolKey @"ConnectionProtocolKey"

static id<ZRURLProtocolDelegate> UrlProtocolDelegate;

@interface ZRURLProtocol () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection * connection;

@end

@implementation ZRURLProtocol

/*
 * 注册到NSURLProtocol里去
 **/
+ (void)start
{
    [NSURLProtocol registerClass:self];
}

+ (id<ZRURLProtocolDelegate>)delegate
{
    id<ZRURLProtocolDelegate> result;
    @synchronized (self) {
        result = UrlProtocolDelegate;
    }
    return result;
}

+ (void)setDelegate:(id<ZRURLProtocolDelegate>)newValue
{
    @synchronized (self) {
        UrlProtocolDelegate = newValue;
    }
}

/**
 *  是否拦截处理指定的请求
 *  @param request 指定的请求
 *  @return 返回YES表示要拦截处理，返回NO表示不拦截处理
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (!request) return request;
    
    /*
     防止无限循环，因为一个请求在被拦截处理过程中，也会发起一个请求，这样又会走到这里，如果不进行处理，就会造成无限循环
     */
    if ([NSURLProtocol propertyForKey:protocolKey inRequest:request]) {
        return NO;
    }
    
    // strongDelegate may be nil
    id<ZRURLProtocolDelegate> strongDelegate;
    strongDelegate = [self delegate];
    if ([strongDelegate respondsToSelector:@selector(URLProtocolEveryURLRequestInWebView:)]) {
        [strongDelegate URLProtocolEveryURLRequestInWebView:request];
    }
    
    // 如果URL是http或https开头，则进行拦截处理，否则不处理
    NSString *scheme = [[request.URL scheme] lowercaseString];
    if ([scheme isEqual:@"http"] || [scheme isEqual:@"https"]) {
        return YES;
    }
    return NO;
}

/**
 *  如果需要对请求进行重定向，添加指定头部操作，重新创建一个NSURLRequest，都可以在该方法中进行
 *  @param request 原请求
 *  @return 修改后的请求
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    // 修改了请求的头部信息/重新定义Request
    NSMutableURLRequest * mutableRequest = [request mutableCopy];

    // strongDelegate may be nil
    id<ZRURLProtocolDelegate> strongDelegate;
    strongDelegate = [self delegate];
    if ([strongDelegate respondsToSelector:@selector(URLProtocolOriginalRequest:)]) {
        mutableRequest = (NSMutableURLRequest * )[strongDelegate URLProtocolOriginalRequest:request];
    }
    
    return mutableRequest;
}

/**
 *  开始加载，在该方法中，加载一个请求
 */
- (void)startLoading {
    NSMutableURLRequest * request = [self.request mutableCopy];
    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:protocolKey inRequest:request];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

/**
 *  取消请求
 */
- (void)stopLoading {
    [self.connection cancel];
}


#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

@end
