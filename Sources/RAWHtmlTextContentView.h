//
//  RAWHtmlTextContentView.h
//  ASKBook
//
//  Created by Developer Meb on 7/19/18.
//

#import <Foundation/Foundation.h>
#import "DTCoreText.h"
#import "RAWHtml.h"
#import "RAWHtmlTextContentViewDefaultDelegate.h"

@protocol RAWHtmlTextContentViewDelegate
-(void)rawHtmlTextSpoilerToggled:(BOOL)show sender:(id)sender;
-(void)rawHtmlTextImageUpdateHeight:(id)sender;
-(void)rawHtmlTextLinkPushed:(NSURL*)url sender:(id)sender;
-(void)rawHtmlTextZoomImage:(UIImageView*)imageView sender:(id)sender;
@end

@protocol RAWHtmlTextContentViewDidfinishDelegate
-(void)rawHtmlTextDidFinish:(id)sender;
@end

@protocol RAWHtmlTextContentViewImageDownloadDelegate
-(UIImageView*)rawHtmlTextContentView:(RAWHtmlTextContentView*)textview downloadImageUrl:(NSURL*)url frame:(CGRect)frame;
@end

@interface RAWHtmlTextContentView : DTAttributedTextContentView {
    RAWHtml *content;
}
- (void)showSpoiler:(BOOL)show;
- (void)setRAWHtmlContent:(RAWHtml*)contentHtml;
@property (nonatomic, strong) RAWHtml *content;
@property (nonatomic, weak) id <RAWHtmlTextContentViewDelegate> rawHtmlTextdelegate;
@property (nonatomic, weak) id <RAWHtmlTextContentViewDidfinishDelegate> didFinishDelegate;
@property (nonatomic, weak) id <RAWHtmlTextContentViewImageDownloadDelegate> downloadImageDelegate;
@end
