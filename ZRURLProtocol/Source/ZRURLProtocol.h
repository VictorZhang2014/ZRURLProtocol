//
//  ZRURLProtocol.h
//  ZRURLProtocol
//
//  Created by VictorZhang on 25/02/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//
//  NSURLProtocol can only intercept the requests in UIWebView, in contrast, it doesn't work in WKWebView
//
// This is Apple Official Demo, see the link
// https://developer.apple.com/library/content/samplecode/CustomHTTPProtocol/Introduction/Intro.html


#import <Foundation/Foundation.h>

@class ZRURLProtocol;

@protocol ZRURLProtocolDelegate <NSObject>

@optional

/*! Implemented this method needs a custom NSURLRequest for returning
 *  Every original request will pass through
 */
- (NSURLRequest *)URLProtocolOriginalRequest:(NSURLRequest *)request;

/*! Implemented this method that gives you every NSURLRequest while webView is requesting
 *  @param request will pass through every request(Like url, header , etc.)
 */
- (void)URLProtocolEveryURLRequestInWebView:(NSURLRequest *)request;

@end



@interface ZRURLProtocol : NSURLProtocol

/*! Call this to start the module.  Prior to this the module is just dormant, and
 *  all HTTP requests proceed as normal.  After this all HTTP and HTTPS requests
 *  go through this module.
 */
+ (void)start;

/*! Sets the delegate for the class.
 *  \details Note that there's one delegate for the entire class, not one per
 *  instance of the class as is more normal.  The delegate is not retained in general,
 *  but is retained for the duration of any given call.  Once you set the delegate to nil
 *  you can be assured that it won't be called unretained (that is, by the time that
 *  -setDelegate: returns, we've already done all possible retains on the delegate).
 *  \param newValue The new delegate to use; may be nil.
 */
+ (void)setDelegate:(id<ZRURLProtocolDelegate>)newValue;

@end

