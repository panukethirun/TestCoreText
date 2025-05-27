//
//  RAWCommentVideoView.m
//  ASKBook
//
//  Created by Developer Meb on 7/20/18.
//

#import "RAWCommentVideoView.h"

@implementation RAWCommentVideoView

@synthesize attachment, wkWebView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString* javascript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:TRUE];
        WKUserContentController *wkUserContentController = [[WKUserContentController alloc] init];
        [wkUserContentController addUserScript:wkUserScript];

        WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = wkUserContentController;
        if (@available(iOS 9.0, *)) {
            config.allowsPictureInPictureMediaPlayback = true;
        } else {
            // Fallback on earlier versions
        }

        wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
        wkWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        if (![wkWebView isKindOfClass:[NSNull class]] && (wkWebView != nil)) {
            [self addSubview:wkWebView];
        }
        [self disableScrolling];
        wkWebView.navigationDelegate = self;
        wkWebView.UIDelegate = self;
    }
    return self;
}

- (void) disableScrolling {
    [wkWebView.scrollView setScrollEnabled:false];
}

- (void)setURLAndLoadWebView:(DTTextAttachment*)attachment {
    if (![attachment isKindOfClass:[NSNull class]] && (attachment != nil)) {
        NSURLRequest *request = [NSURLRequest requestWithURL:attachment.contentURL];
        NSLog(@"url : %@",attachment.contentURL);
        self.attachment = attachment;
        self.attachment = attachment;
        [wkWebView loadRequest:request];
    }
}

// MARK: wkWebViewDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Error : %@",error);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
@end
