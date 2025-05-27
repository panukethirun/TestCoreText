//
//  DTSpoilTextAttachment.m
//  ASKBook
//
//  Created by Developer Meb on 9/13/18.
//

#import "DTSpoilTextAttachment.h"
#import "RAWHtml.h"

@implementation DTSpoilTextAttachment
@synthesize spoilText;


- (id)initWithElement:(DTHTMLElement *)element options:(NSDictionary *)options
{
    self = [super initWithElement:element options:options];
    
    if (self)
    {
        // get comment_text
        NSString *text = [element.attributes objectForKey:@"text"];
        NSLog(@"%@",element.attributedString);
        
        [self setDisplaySize:[self getSizeSpoilViewMeb]];
        [self setOriginalSize:[self getSizeSpoilViewMeb]];
        
        if(text){
            RAWHtml *newModel = [[RAWHtml alloc] initWithHtmlText:text];
            spoilText = [newModel attributedString];
        }
    }
    
    return self;
}

- (CGSize)getSizeSpoilViewMeb{
    CGSize size;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
                
            case 1136:
                //                printf("iPhone 5 or 5S or 5C");
                size = CGSizeMake(260, 100);
                break;
            case 1334:
                //                printf("iPhone 6/6S/7/8");
                size = CGSizeMake(310, 100);
                break;
            case 1920:
            case 2208:
                //                printf("iPhone 6+/6S+/7+/8+");
                size = CGSizeMake(340, 100);
                break;
            case 2436:
                //                printf("iPhone X");
                size = CGSizeMake(310, 100);
                break;
            default:
                size = CGSizeMake(260, 100);
        }
    }
    else {
        size = CGSizeMake(400, 180);
    }
    return size;
}
#pragma mark - DTTextAttachmentHTMLEncoding

- (NSString *)stringByEncodingAsHTML
{
    NSMutableString *retString = [NSMutableString string];
    
    [retString appendString:@"<div class=\"spoiler\"><div class=\"spoiler-title\"><div class=\"spoiler-toggle show-icon\">&nbsp;</div><span class=\"spoiler-show-text\">แสดงสปอยล์</span></div><div class=\"spoiler-content\" style=\"display: none;\"><p>"];
    
    if (![[spoilText string] isEqualToString:@""] && spoilText != nil)
    {
        NSString *textString = [spoilText string];
        textString = [textString stringByReplacingOccurrencesOfString:@"\n" withString:@"</p><p>"];
        [retString appendFormat:@"%@", [RAWHtml xmlSimpleUnescapeString:textString]];
    }

    [retString appendString:@"</p></div></div>"];
    
    return retString;
}

//- (void)textViewDidChange:(UITextView *)textView {
//    spoilText = textView.text;
//}

- (void)editorViewDidChange:(DTRichTextEditorView *)editorView{
    spoilText = editorView.attributedText;
}

@end
