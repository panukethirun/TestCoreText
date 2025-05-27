//
//  RAWHtml.m
//  ASKBook
//
//  Created by Developer Meb on 7/19/18.
//

#import "RAWHtml.h"
#import "DTCoreText.h"
#import <UIKit/UIKitDefines.h>
#import "DTSpoilTextAttachment.h"

@implementation RAWHtml

@synthesize COMMENT_CSS, originalHtmlText, hasSpoiler, isSpoilerShow, _options, attributedString;
@synthesize lang;

+ (void)initialize
{
    // this gets called from each subclass
    // prevent calling from children
    if (self != [RAWHtml class])
    {
        return;
    }
    // register standard tags
    [DTTextAttachment registerClass:[DTSpoilTextAttachment class] forTagName:@"spoiler"];
}

-(instancetype)initWithHtmlText:(NSString*)htmlText{
    COMMENT_CSS = [self getDefaultCSS];
    originalHtmlText = [NSString stringWithFormat:@""];
    hasSpoiler = false;
    originalHtmlText = [RAWHtml xmlSimpleUnescapeString:htmlText];
    [self loadHtmlText:htmlText];
    
    return self;
}

-(instancetype)initWithHtmlText:(NSString*)htmlText setOptions:(NSDictionary*)options{
    _options = options;
    lang = options[@"lang"];
    COMMENT_CSS = [self getDefaultCSS];
    originalHtmlText = [NSString stringWithFormat:@""];
    hasSpoiler = false;
    originalHtmlText = [RAWHtml xmlSimpleUnescapeString:htmlText];
    [self loadHtmlText:htmlText setOptions:options];
    
    return self;
}
-(instancetype)initWithHtmlText:(NSString*)htmlText setOptions:(NSDictionary*)options isShowSpoiler:(BOOL)isShowSpoiler{
    _options = options;
    lang = options[@"lang"];
    COMMENT_CSS = [self getDefaultCSS];
    originalHtmlText = [NSString stringWithFormat:@""];
    hasSpoiler = true;
    originalHtmlText = [RAWHtml xmlSimpleUnescapeString:htmlText];
    [self loadHtmlText:htmlText showSpoiler:isShowSpoiler setOptions:options];
    
    return self;
}

-(NSString*)getDefaultCSS{
    return [NSString stringWithFormat:@"div.spoiler{padding:5px;line-height:1.6;width:300px;margin:0 auto;}div.spoiler-title{color:#6d6e71;font-weight:400;padding:4px 7px 4px 7px;background:#ebeced;border:1px solid #bbb;text-align:center;}div.spoiler-toggle{display:inline-block;height:11px;line-height:14px;margin-left:4px;margin-right:6px}div.spoiler-content{border:1px;border-top:0;color:#6d6e71;background:#f5f5f5;padding:4px 10px}.videodetector{position:relative;width:300px;height:200px;padding-bottom:15px}.videodetector iframe{position:absolute;top:0;left:0;width:300px;height:200px}.remove-videodetector{position:absolute;top:15px;left:15px;z-index:999;display:none;outline:0;padding:10px 20px;appearance:none;box-shadow:0 2px 6px rgba(0,0,0,.2);border-radius:3px;border:none;background-color:#e74c3c;color:#fff;font-weight:700;font-size:12px;text-transform:uppercase}.remove-videodetector:hover{background-color:#c0392b}.videodetector:hover .remove-videodetector{display:none}p.AlignCenter{text-indent:0;text-align:center;margin-bottom:22px}"];
}

-(void)loadHtmlText:(NSString*)htmlText{
    hasSpoiler = [htmlText containsString:@"<div class=\"spoiler\""];
    [self loadHtmlText:htmlText showSpoiler:false];
}

-(void)loadHtmlText:(NSString*)htmlText setOptions:(NSDictionary*)options{
    hasSpoiler = [htmlText containsString:@"<div class=\"spoiler\""];
    [self loadHtmlText:htmlText showSpoiler:false setOptions:options];
}

-(void)loadHtmlText:(NSString*)htmlText showSpoiler:(BOOL)showSpoiler{
    UIColor *color = UIColor.blackColor;
    float fontSize = 14;
    CGSize size = CGSizeMake(325.0, 1000.0);
    NSString *fontFamily = [NSString stringWithFormat:@"MEBCloudLoop"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], DTUseiOS6Attributes,
                             [NSNumber numberWithFloat:fontSize],DTDefaultFontSize,
                             [UIColor colorWithCGColor:color.CGColor],DTDefaultTextColor,
                             [NSValue valueWithCGSize:size],DTMaxImageSize,
                             [[DTCSSStylesheet alloc] initWithStyleBlock:COMMENT_CSS],DTDefaultStyleSheet,
                             [NSString stringWithString:fontFamily],DTDefaultFontFamily,
                             [NSString stringWithString:fontFamily],DTDefaultFontName,
                             [NSNumber numberWithBool:YES], DTProcessCustomHTMLAttributes,
                             [NSNumber numberWithFloat:1.5], DTDefaultLineHeightMultiplier,
                             nil];
    _options = options;
    [self loadHtmlText:htmlText showSpoiler:showSpoiler setOptions:options];
}
-(void)loadHtmlText:(NSString*)htmlText showSpoiler:(BOOL)showSpoiler setOptions:(NSDictionary*)options{
    NSString *displayText = [NSString stringWithString:htmlText];
    NSString *tempText = [NSString stringWithString:htmlText];
    
    NSString* showSpoilText = @"แสดงสปอยล์";
    NSString* hideSpoilText = @"ซ่อนสปอยล์";
    if (lang != nil && ![lang isEqualToString:@"(null)"] && [lang isEqualToString:@"en"]){
        showSpoilText = @"Show spoiler";
        hideSpoilText = @"Hide spoiler";
    }


    //encode image src
    NSMutableArray *srcList = [[NSMutableArray alloc]init];
    NSMutableArray *encodeSrcList = [[NSMutableArray alloc]init];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(src\\s*=\\s*\"(.+?)\")|(href\\s*=\\s*\"(.+?)\")" options:0 error:&error];
    NSArray *matches = [regex matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length])];
    NSUInteger matchCount = [matches count];
    if (matchCount) {
        for (NSUInteger matchIdx = 0; matchIdx < matchCount; matchIdx++) {
            NSTextCheckingResult *match = [matches objectAtIndex:matchIdx];
            NSRange matchRange = [match range];
            NSString *result = [htmlText substringWithRange:matchRange];
            
            NSString *inner_src = [self getAttributeValueFromString:result];
            
            if (inner_src != nil) {
                //add src_list for keep original string
                [srcList addObject:inner_src];
                
                //add encode_list
                NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
                NSString *encode_src = [inner_src stringByAddingPercentEncodingWithAllowedCharacters:set];
                [encodeSrcList addObject:encode_src];
            }
        }
        for (int index = 0; index < [encodeSrcList count]; index++)
        {
            // replace original string to encode string
            tempText = [tempText stringByReplacingOccurrencesOfString:srcList[index] withString:encodeSrcList[index]];
        }
        
        displayText = [NSString stringWithString:tempText];
    }
    else {  // Nah... No matches.
    }
    
    if (hasSpoiler) {
        if([htmlText containsString:@"<span>แสดงสปอยล์</span>"]){
            displayText = [htmlText stringByReplacingOccurrencesOfString:@"<span>แสดงสปอยล์</span>" withString:@"<span class=\"spoiler-show-text\">แสดงสปอยล์</span>"];
        }
        

        NSError *error = nil;
        NSRegularExpression *regexSpoilerContent = [NSRegularExpression regularExpressionWithPattern:@"class=\"spoiler-content\" style=\"display:\\s*.*?\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSRegularExpression *regexSpoilerContentWithoutStyle = [NSRegularExpression regularExpressionWithPattern:@"class=\"spoiler-content\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSRegularExpression *regexSpoilerButton = [NSRegularExpression regularExpressionWithPattern:@"<span class=\"spoiler-.*?-text\".*?</span>" options:NSRegularExpressionCaseInsensitive error:&error];
        if (showSpoiler) {
            NSString *tempText = [regexSpoilerContent stringByReplacingMatchesInString:displayText options:0 range:NSMakeRange(0, [displayText length]) withTemplate:@"class=\"spoiler-content\" style=\"display: block;\""];
            if ([tempText rangeOfString:@"style="].location == NSNotFound){
                tempText = [regexSpoilerContentWithoutStyle stringByReplacingMatchesInString:displayText options:0 range:NSMakeRange(0, [displayText length]) withTemplate:@"class=\"spoiler-content\" style=\"display: block;\""];
            }
            displayText = [regexSpoilerButton stringByReplacingMatchesInString:tempText options:0 range:NSMakeRange(0, [tempText length]) withTemplate:[NSString stringWithFormat:@"<span class=\"spoiler-hide-text\">%@</span>", hideSpoilText]];

            isSpoilerShow = TRUE;
        }
        else {
            NSString *tempText = [regexSpoilerContent stringByReplacingMatchesInString:displayText options:0 range:NSMakeRange(0, [displayText length]) withTemplate:@"class=\"spoiler-content\" style=\"display: none;\""];
            if ([tempText rangeOfString:@"style="].location == NSNotFound){
                tempText = [regexSpoilerContentWithoutStyle stringByReplacingMatchesInString:displayText options:0 range:NSMakeRange(0, [displayText length]) withTemplate:@"class=\"spoiler-content\" style=\"display: none;\""];
            }
            displayText = [regexSpoilerButton stringByReplacingMatchesInString:tempText options:0 range:NSMakeRange(0, [tempText length]) withTemplate:[NSString stringWithFormat:@"<span class=\"spoiler-show-text\">%@</span>",showSpoilText]];

            isSpoilerShow = FALSE;
        }
    }
    
    
    NSData *data = [displayText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithHTMLData:data options:options documentAttributes:nil];
    
    [mutableAttributedString enumerateAttribute:DTCustomAttributesAttribute inRange:NSMakeRange(0, mutableAttributedString.length) options:0 usingBlock:^(id attr, NSRange range, BOOL *stop) {
        if([[attr objectForKey:@"class"] isEqualToString:@"spoiler-show-text"]) {
            NSURL *url = [NSURL URLWithString:@"comment:show-spoiler"];
            [mutableAttributedString addAttributes:@{NSLinkAttributeName:url} range:range];
        }
        else if([[attr objectForKey:@"class"] isEqualToString:@"spoiler-hide-text"]) {
            NSURL *url = [NSURL URLWithString:@"comment:hide-spoiler"];
            [mutableAttributedString addAttributes:@{NSLinkAttributeName:url} range:range];
        }
    }];
    
    
    
    [mutableAttributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, mutableAttributedString.length) options:0 usingBlock:^(id attr, NSRange range, BOOL *stop) {
        if ([attr isKindOfClass:[DTImageTextAttachment class]])
        {
            DTImageTextAttachment *attachment = (DTImageTextAttachment *)attr;
            if (isnan(attachment.displaySize.height) || isnan(attachment.displaySize.width)) {
                attachment.displaySize = CGSizeZero;
            }
        }
    }];
    
    attributedString = mutableAttributedString;
}
-(instancetype)initWithHtmlTextForEditComment:(NSString*)htmlText setOptions:(NSMutableDictionary*)options widthTextView:(CGFloat)width heightTextView:(CGFloat)height {
    NSString *displayText = [NSString stringWithString:[RAWHtml xmlSimpleUnescapeString:htmlText]];
    NSString *tempText = [NSString stringWithString:[RAWHtml xmlSimpleUnescapeString:htmlText]];
    
    NSString* showSpoilText = @"แสดงสปอยล์";
    if (lang == nil){
        lang = options[@"lang"];
    }
    if (lang != nil && ![lang isEqualToString:@"(null)"] && [lang isEqualToString:@"en"]){
        showSpoilText = @"Show spoiler";
    }
    

    //encode image src
    NSMutableArray *srcList = [[NSMutableArray alloc]init];
    NSMutableArray *encodeSrcList = [[NSMutableArray alloc]init];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(src\\s*=\\s*\"(.+?)\")|(href\\s*=\\s*\"(.+?)\")" options:0 error:&error];
    NSArray *matches = [regex matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length])];
    NSUInteger matchCount = [matches count];
    if (matchCount) {
        for (NSUInteger matchIdx = 0; matchIdx < matchCount; matchIdx++) {
            NSTextCheckingResult *match = [matches objectAtIndex:matchIdx];
            NSRange matchRange = [match range];
            NSString *result = [htmlText substringWithRange:matchRange];
            
            NSString *inner_src = [self getAttributeValueFromString:result];
            
            if (inner_src != nil) {
                //add src_list for keep original string
                [srcList addObject:inner_src];
                
                //add encode_list
                NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
                NSString *encode_src = [inner_src stringByAddingPercentEncodingWithAllowedCharacters:set];
                [encodeSrcList addObject:encode_src];
            }
        }
        for (int index = 0; index < [encodeSrcList count]; index++)
        {
            // replace original string to encode string
            tempText = [tempText stringByReplacingOccurrencesOfString:srcList[index] withString:encodeSrcList[index]];
        }
        
        displayText = [NSString stringWithString:tempText];
    }
    else {  // Nah... No matches.
    }
    
    error = nil;
    NSRegularExpression *regexSpoilerContent = [NSRegularExpression regularExpressionWithPattern:@"class=\"spoiler-content\" style=\"display: .*?\"" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *regexSpoilerButton = [NSRegularExpression regularExpressionWithPattern:@"<span class=\"spoiler-.*?-text\".*?</span>" options:NSRegularExpressionCaseInsensitive error:&error];
    tempText = [regexSpoilerContent stringByReplacingMatchesInString:displayText options:0 range:NSMakeRange(0, [displayText length]) withTemplate:@"class=\"spoiler-content\" style=\"display: none;\""];
    displayText = [regexSpoilerButton stringByReplacingMatchesInString:tempText options:0 range:NSMakeRange(0, [tempText length]) withTemplate:[NSString stringWithFormat:@"<span class=\"spoiler-show-text\">%@</span>",showSpoilText]];

    isSpoilerShow = FALSE;
    
    NSLog(@"%@",displayText);
    NSLog(@"%@" ,[self escapeSpoil:displayText]);
    
    displayText = [self escapeSpoil:displayText];
    
    // change tag to spoilAttachment
    NSString *setSizeSpoiler = [NSString stringWithFormat:@"<spoiler width=\"%f\"; height=\"%f\"; text=\"", width, height];
    displayText = [displayText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<div class=\"spoiler\"><div class=\"spoiler-title\"><div class=\"spoiler-toggle show-icon\"></div><span class=\"spoiler-show-text\">%@</span></div><div class=\"spoiler-content\" style=\"display: none;\">", showSpoilText] withString:setSizeSpoiler];

    displayText = [displayText stringByReplacingOccurrencesOfString:@"</div></div>" withString:@"\"></spoiler>"];
    
    NSData *data = [displayText dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",displayText);
    
    //check nan
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithHTMLData:data options:options documentAttributes:nil];
    [mutableAttributedString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, mutableAttributedString.length) options:0 usingBlock:^(id attr, NSRange range, BOOL *stop) {
        if ([attr isKindOfClass:[DTImageTextAttachment class]])
        {
            DTImageTextAttachment *attachment = (DTImageTextAttachment *)attr;
            if (isnan(attachment.displaySize.height) || isnan(attachment.displaySize.width)) {
                attachment.displaySize = CGSizeZero;
            }
        }
    }];
    
    attributedString = mutableAttributedString;
    
    return self;
}

-(NSString*)escapeSpoil:(NSString*)htmlText{
    //escape text in spoil src
    
    NSString *displayText = [NSString stringWithString:[RAWHtml xmlSimpleUnescapeString:htmlText]];
    NSString *tempText = [NSString stringWithString:[RAWHtml xmlSimpleUnescapeString:htmlText]];
    
    NSError *error = NULL;
    NSMutableArray *spoilList = [[NSMutableArray alloc]init];
    NSMutableArray *escapeSpoilList = [[NSMutableArray alloc]init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<div class=\"spoiler\"><div class=\"spoiler-title\"><div class=\"spoiler-toggle show-icon\"></div>.*?</div></div>|<div class=\"videodetector\">\\s*(.+?)\\s*</div>" options:0 error:&error];
    NSArray *matches = [regex matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length])];
    NSUInteger matchCount = [matches count];
    
    if (matchCount) {
        for (NSUInteger matchIdx = 0; matchIdx < matchCount; matchIdx++) {
            NSTextCheckingResult *match = [matches objectAtIndex:matchIdx];
            NSRange matchRange = [match range];
            NSString *result = [htmlText substringWithRange:matchRange];
            
            NSString *inner_src = [self getAttributeValueFromSpoil:result];
            
            if (inner_src != nil) {
                //add spoil_list for keep original string
                [spoilList addObject:inner_src];
                
                //add escape_list
                NSString *encode_src = [RAWHtml xmlSimpleEscapeString:inner_src];
                [escapeSpoilList addObject:encode_src];
            }
        }
        for (int index = 0; index < [escapeSpoilList count]; index++)
        {
            // replace original string to encode string
            tempText = [tempText stringByReplacingOccurrencesOfString:spoilList[index] withString:escapeSpoilList[index]];
        }
        
        displayText = [NSString stringWithString:tempText];
        return [NSString stringWithFormat:@"%@", displayText];
    }
    else {  // Nah... No matches.
        return [NSString stringWithFormat:@"%@", displayText];
    }
}


-(void)showSpoiler:(BOOL)show{
    if (hasSpoiler) {
        [self loadHtmlText:originalHtmlText showSpoiler:show setOptions:_options];
    }
    
}

-(NSString*)getAttributeValueFromString:(NSString*)attributeString {
    NSString* result = @"";
    result = [self getSubString:attributeString fromRangeOfString:@"\"" endWith:@"\""];
    return result;
}

-(NSString*)getAttributeValueFromSpoil:(NSString*)attributeString {
    
    NSString* showSpoilText = @"แสดงสปอยล์";
    if (lang != nil && ![lang isEqualToString:@"(null)"] && [lang isEqualToString:@"en"]){
        showSpoilText = @"Show spoiler";
    }
    

    NSString* result = @"";
    result = [self getSubString:attributeString fromRangeOfString:[NSString stringWithFormat:@"<div class=\"spoiler\"><div class=\"spoiler-title\"><div class=\"spoiler-toggle show-icon\"></div><span class=\"spoiler-show-text\">%@</span></div><div class=\"spoiler-content\" style=\"display: none;\">", showSpoilText] endWith:@"</div></div>"];

    return result;
}

-(NSString *)getSubString:(NSString *)string fromRangeOfString:(NSString *)rangeStr endWith:(NSString *)endStr{
    NSString *param = @"";
    NSRange start = [string rangeOfString:rangeStr];
    if (start.location != NSNotFound)
    {
        param = [string substringFromIndex:start.location + start.length];
        NSRange end = [param rangeOfString:endStr];
        if (end.location != NSNotFound)
        {
            param = [param substringToIndex:end.location];
        }
    }
    return param;
}

// Encode NSString for XML/HTML
+ (NSString *)xmlSimpleUnescapeString:(NSString *)htmlString
{
    NSMutableString *unescapeStr = [NSMutableString stringWithString:htmlString];
    
    return [RAWHtml xmlSimpleUnescape:unescapeStr];
}


+ (NSString *)xmlSimpleEscapeString:(NSString *)htmlString
{
    NSMutableString *escapeStr = [NSMutableString stringWithString:htmlString];
    
    return [RAWHtml xmlSimpleEscape:escapeStr];
}
+ (NSMutableString *)xmlSimpleUnescape:(NSMutableString*)htmlMutableString
{
    [htmlMutableString replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&#x27;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&#39;"  withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&#x92;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&#x96;" withString:@"-"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"&nbsp;"   withString:@""  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"\n"   withString:@""  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    
    return htmlMutableString;
}

+ (NSMutableString *)xmlSimpleEscape:(NSMutableString*)htmlMutableString
{
    [htmlMutableString replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"'"  withString:@"&#x27;" options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    [htmlMutableString replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [htmlMutableString length])];
    
    return htmlMutableString;
}
@end
