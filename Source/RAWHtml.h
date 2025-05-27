//
//  RAWHtml.h
//  ASKBook
//
//  Created by Developer Meb on 7/19/18.
//

#import <Foundation/Foundation.h>
#import "DTCoreText.h"

@interface RAWHtml : NSObject {
    NSString *COMMENT_CSS;
    
    NSString *originalHtmlText;
    NSAttributedString *attributedString;
    BOOL isSpoilerShow;
    BOOL hasSpoiler;
    NSDictionary *_options;
    NSString* lang;

}
-(void)showSpoiler:(BOOL)show;
-(instancetype)initWithHtmlText:(NSString*)htmlText;
-(instancetype)initWithHtmlText:(NSString*)htmlText setOptions:(NSDictionary*)options;
-(instancetype)initWithHtmlText:(NSString*)htmlText setOptions:(NSDictionary*)options isShowSpoiler:(BOOL)isShowSpoiler;
-(instancetype)initWithHtmlTextForEditComment:(NSString*)htmlText setOptions:(NSMutableDictionary*)options widthTextView:(CGFloat)width heightTextView:(CGFloat)height;

+ (NSString *)xmlSimpleEscapeString:(NSString *)htmlString;
+ (NSString *)xmlSimpleUnescapeString:(NSString *)htmlString;
- (NSString *)getSubString:(NSString *)string fromRangeOfString:(NSString *)rangeStr endWith:(NSString *)endStr;

@property (nonatomic, strong) NSString *COMMENT_CSS;
@property (nonatomic, strong) NSString *originalHtmlText;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, assign) BOOL isSpoilerShow;
@property (nonatomic, assign) BOOL hasSpoiler;
@property (nonatomic, strong) NSDictionary *_options;
@property (nonatomic, strong) NSString *lang;

@end
