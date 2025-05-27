//
//  RAWHtmlTextContentViewDefaultDelegate.h
//  ASKBook
//
//  Created by Developer Meb on 7/20/18.
//

#import <Foundation/Foundation.h>
#import "DTCoreText.h"
#import "RAWDTWebVideoView.h"

@class RAWHtmlTextContentView;

@interface RAWHtmlTextContentViewDefaultDelegate : NSObject <DTAttributedTextContentViewDelegate, RAWDTWebVideoViewDelegate> {
    __weak RAWHtmlTextContentView *contentView;
    

}
-(instancetype)initWithContentView:(RAWHtmlTextContentView*)htmlTextContentView;
@property (nonatomic,weak) RAWHtmlTextContentView *contentView;

@end
