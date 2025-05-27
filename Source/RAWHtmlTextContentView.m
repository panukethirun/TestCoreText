//
//  RAWHtmlTextContentView.m
//  ASKBook
//
//  Created by Developer Meb on 7/19/18.
//

#import "RAWHtmlTextContentView.h"
#import "RAWHtmlTextContentViewDefaultDelegate.h"

@implementation RAWHtmlTextContentView {
    RAWHtmlTextContentViewDefaultDelegate *defaultDelegate;
}

@synthesize content, rawHtmlTextdelegate, didFinishDelegate, downloadImageDelegate;

- (void)awakeFromNib{
    [super awakeFromNib];
    self.shouldDrawImages = false;
    self.layoutFrameHeightIsConstrainedByBounds = true;
    defaultDelegate = [[RAWHtmlTextContentViewDefaultDelegate alloc] initWithContentView:self];
    self.delegate = defaultDelegate;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldDrawImages = false;
        defaultDelegate = [[RAWHtmlTextContentViewDefaultDelegate alloc] initWithContentView:self];
        self.delegate = defaultDelegate;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.shouldDrawImages = false;
        defaultDelegate = [[RAWHtmlTextContentViewDefaultDelegate alloc] initWithContentView:self];
        self.delegate = defaultDelegate;
    }
    return self;
}

- (void)setRAWHtmlContent:(RAWHtml*)contentHtml {
    content = contentHtml;
    self.attributedString = contentHtml.attributedString;
}

- (void)showSpoiler:(BOOL)show
{
    [content showSpoiler:show];
    self.attributedString = content.attributedString;
    [self relayoutText];
    if (self.rawHtmlTextdelegate != nil) {
        [self.rawHtmlTextdelegate rawHtmlTextSpoilerToggled:show sender:self];
    }
}

@end
