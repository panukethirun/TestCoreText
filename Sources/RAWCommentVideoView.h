//
//  RAWCommentVideoView.h
//  ASKBook
//
//  Created by Developer Meb on 7/20/18.
//

#import <UIKit/UIKit.h>
#import "DTCoreText.h"
#import <WebKit/WebKit.h>

@interface RAWCommentVideoView : UIView <WKNavigationDelegate, WKUIDelegate> {
    DTTextAttachment *attachment;
    WKWebView *wkWebView;
}
- (void)setURLAndLoadWebView:(DTTextAttachment*)attachment;
@property (nonatomic,strong) DTTextAttachment *attachment;
@property (nonatomic,strong) WKWebView *wkWebView;
@end
