//
//  DTWebVideoView.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 8/5/11.
//  Copyright 2011 Drobnik.com. All rights reserved.
//

#import "RAWDTWebVideoView.h"
#import "DTCoreText.h"

@interface RAWDTWebVideoView ()

- (void)disableScrolling;

@end


@implementation RAWDTWebVideoView
{
	DTTextAttachment *_attachment;
	
    DT_WEAK_VARIABLE id <RAWDTWebVideoViewDelegate> _delegate;
	
	WKWebView *_webView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.userInteractionEnabled = YES;
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
		
        if ([_webView respondsToSelector:@selector(setAllowsInlineMediaPlayback:)])
        {
            _webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
        }else{
            _webView = [[WKWebView alloc] initWithFrame:self.bounds];
        }
        
		_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_webView];
		
		[self disableScrolling];
		
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return self;
}

- (void)dealloc
{
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
}


- (void)disableScrolling
{
	// find scrollview and disable scrolling
	for (UIView *oneView in _webView.subviews)
	{
		if ([oneView isKindOfClass:[UIScrollView class]])
		{
			UIScrollView *scrollView = (id)oneView;
			
			scrollView.scrollEnabled = NO;
			scrollView.bounces = NO;
			
			return;
		}
	}	
}

#pragma mark WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    // allow the embed request for YouTube
    if (NSNotFound != [[[navigationAction.request URL] absoluteString] rangeOfString:@"www.youtube.com/embed/"].location)
    {
        return decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    // allow the embed request for DailyMotion Cloud
    if (NSNotFound != [[[navigationAction.request URL] absoluteString] rangeOfString:@"api.dmcloud.net/player/embed/"].location)
    {
        return decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    BOOL shouldOpenExternalURL = YES;
    
    if ([_delegate respondsToSelector:@selector(videoView:shouldOpenExternalURL:)])
    {
        shouldOpenExternalURL = [_delegate videoView:self shouldOpenExternalURL:[navigationAction.request URL]];
    }
    
#if !defined(DT_APP_EXTENSIONS)
    if (shouldOpenExternalURL)
    {
        [[UIApplication sharedApplication] openURL:[navigationAction.request URL] options:@{} completionHandler:nil];
    }
#endif
    
    return decisionHandler(WKNavigationActionPolicyCancel);
    
}

#pragma mark Properties

- (void)setAttachment:(DTTextAttachment *)attachment
{
	if (_attachment != attachment)
	{
		
		_attachment = attachment;
		
		if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
		{
			NSURLRequest *request = [NSURLRequest requestWithURL:attachment.contentURL];
			[_webView loadRequest:request];
		}
	}
}

@synthesize delegate = _delegate;
@synthesize attachment = _attachment;

@end
