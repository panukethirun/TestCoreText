//
//  RAWHtmlTextContentViewDefaultDelegate.m
//  ASKBook
//
//  Created by Developer Meb on 7/20/18.
//

#import "RAWHtmlTextContentViewDefaultDelegate.h"
#import "RAWCommentVideoView.h"
#import "RAWHtmlTextContentView.h"
//#import <SDWebImage/UIImageView+WebCache.h>
//#import <SDWebImage/FLAnimatedImageView+WebCache.h>
//#import "UIImageView+WebCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLAnimatedImageView.h"


@implementation RAWHtmlTextContentViewDefaultDelegate

@synthesize contentView;

-(instancetype)initWithContentView:(RAWHtmlTextContentView*)htmlTextContentView{
    contentView = htmlTextContentView;
    return self;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        if (self.contentView.downloadImageDelegate == nil) {
            
            // handle for rating_image in Meb (MyReview)
            if  ([attachment.contentURL.absoluteString rangeOfString:@".mebReview"].location != NSNotFound) {
                FLAnimatedImageView *imageView;
                imageView = [[FLAnimatedImageView alloc] initWithFrame:frame];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                NSString *nameRatingImage = [attachment.contentURL.absoluteString stringByReplacingOccurrencesOfString:@".mebReview" withString:@""];
                [imageView setImage:[UIImage imageNamed:nameRatingImage]];
                return imageView;
            }
            else {
                FLAnimatedImageView *imageView;
                //DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:CGRectZero];
                if (!(isnan(frame.size.height)) && !(isnan(frame.size.width)) && !(isnan(frame.origin.x)) && !(isnan(frame.origin.y))) {
                    imageView = [[FLAnimatedImageView alloc] initWithFrame:frame];
                } else {
                    imageView = [[FLAnimatedImageView alloc] init];
                }
                [imageView sd_setImageWithURL:attachment.contentURL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (image != nil) {
                        [self imageTextAttachmentDownloadCompletedWithURL:attachment.contentURL image:image];
                    }
                }];
                return imageView;
            }
        } else {
            return [self.contentView.downloadImageDelegate rawHtmlTextContentView:self.contentView downloadImageUrl:attachment.contentURL frame:frame];
        }
        
    }
    else if ([attachment isKindOfClass:[DTIframeTextAttachment class]]) {
        RAWCommentVideoView *videoView = [[RAWCommentVideoView alloc] initWithFrame: frame];
        [videoView setURLAndLoadWebView:attachment];
        videoView.backgroundColor = UIColor.redColor;

//        RAWDTWebVideoView *videoView = [[RAWDTWebVideoView alloc] initWithFrame:frame];
//        videoView.attachment = attachment;
        return videoView;
    }
    else {
        
    }
    return nil;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame {
    NSString *string_url = url.absoluteString;
    if  ([string_url isEqualToString:@"comment:show-spoiler"] ||  ([string_url isEqualToString:@"comment:hide-spoiler"]) ) {
        DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
        button.URL = url;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            button.minimumHitSize = CGSizeMake(110, 30); // adjusts it's bounds so that button is always large enough
        }
        else{
            button.minimumHitSize = CGSizeMake(90, 30); // adjusts it's bounds so that button is always large enough
        }
        button.GUID = identifier;
        
        unsigned rgbValue = 0;
        
        // init color from hexString
        NSScanner *scanner = [NSScanner scannerWithString:@"#057AFF"];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        UIColor *buleIos = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];

        int font_size = [[contentView.content._options objectForKey:@"DTDefaultFontSize"] intValue];
        NSString *font_family = [contentView.content._options objectForKey:@"DTDefaultFontFamily"];
        UIColor *spoilButtonBGColor = [[contentView.content._options objectForKey:@"SpoilButtonBGColor"] colorWithAlphaComponent:1];
        if(spoilButtonBGColor == nil){
            spoilButtonBGColor = UIColor.clearColor;
        }
        
        [button setTitleColor:buleIos forState:UIControlStateNormal];
        if ([string_url isEqualToString:@"comment:show-spoiler"]) {
//            [button setTitle:@"แสดงสปอยล์" forState:UIControlStateNormal];
            [button setBackgroundColor:spoilButtonBGColor];
            [button.titleLabel setFont:[UIFont fontWithName:font_family size:font_size - 1]];
        }
        else {
//            [button setTitle:@"ซ่อนสปอยล์" forState:UIControlStateNormal];
            [button setBackgroundColor:spoilButtonBGColor];
            [button.titleLabel setFont:[UIFont fontWithName:font_family size:font_size - 1]];
        }
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        // use normal push action for opening URL
        [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    }
    else {
        DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
        button.URL = url;
        button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
        button.GUID = identifier;
        
        // use normal push action for opening URL
        [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    }
}
    
- (void)imageTextAttachmentDownloadCompletedWithURL:(nullable NSURL *)url image:(UIImage *)image {
 CGSize imageSize = image.size;
 NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
 
 BOOL didUpdate = NO;
 // update all attachments that match this URL (possibly multiple images with same size)
 for (DTTextAttachment *oneAttachment in [self.contentView.layoutFrame textAttachmentsWithPredicate:pred])
 {
     // update attachments that have no original size, that also sets the display size
     if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero) || (oneAttachment.originalSize.width == CGSizeZero.width) || (oneAttachment.originalSize.height == CGSizeZero.height))
     {
         oneAttachment.originalSize = imageSize;
         
         didUpdate = YES;
     }
 }
 
 if (didUpdate)
 {
     // layout might have changed due to image sizes
     // do it on next run loop because a layout pass might be going on
     dispatch_async(dispatch_get_main_queue(), ^{
         self.contentView.layouter = nil;
         [self.contentView relayoutText];
         if (self.contentView.rawHtmlTextdelegate != nil) {
             [self.contentView.rawHtmlTextdelegate rawHtmlTextImageUpdateHeight:self.contentView];
         }
     });
 }
}

- (void)linkPushed:(DTLinkButton *)button
{
    NSURL *URL = button.URL;
    NSString *string_url = button.URL.absoluteString;
    DTAttributedTextView *textView = (DTAttributedTextView*)self.contentView;
    if ([string_url isEqualToString:@"comment:show-spoiler"]) {
        [self.contentView showSpoiler:TRUE];
    }
    else if ([string_url isEqualToString:@"comment:hide-spoiler"]) {
        [self.contentView showSpoiler:FALSE];
    }
    else {
        if (contentView.rawHtmlTextdelegate != nil) {
            [contentView.rawHtmlTextdelegate rawHtmlTextLinkPushed:URL sender:self.contentView];
        } else {
            if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]])
            {
                [[UIApplication sharedApplication] openURL:[URL absoluteURL] options:@{} completionHandler:nil];
            }
            else
            {
                if (![URL host] && ![URL path])
                {
                    
                    // possibly a local anchor link
                    NSString *fragment = [URL fragment];
                    
                    if (fragment)
                    {
                        [textView scrollToAnchorNamed:fragment animated:NO];
                    }
                }
            }
        }
    }

}

- (void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView didDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context {
    if (self.contentView.didFinishDelegate != nil) {
        [self.contentView.didFinishDelegate rawHtmlTextDidFinish:self];
    }
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:5];
    
    if(textBlock.padding.left == 8.1 && textBlock.padding.right == 8.1 && textBlock.padding.top == 4.1 && textBlock.padding.bottom == 4.1){
        CGColorRef color = textBlock.backgroundColor.CGColor;
        if(color){
            CGContextSetFillColorWithColor(context, color);
        }
        CGContextAddPath(context, [bezierPath CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [bezierPath CGPath]);
        CGContextSetRGBStrokeColor(context, 154.0/255.0, 154.0/255.0, 154.0/255.0, 1);
        CGFloat dashLengths[] = {2.0f, 2.0f};
        CGContextSetLineDash(context, 0.0f, dashLengths, 2);
        CGContextStrokePath(context);
        return false;
    }
    return true;
}
@end
