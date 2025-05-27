#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#if TARGET_OS_IPHONE
#import <CoreText/CoreText.h>
#elif TARGET_OS_MAC
#import <ApplicationServices/ApplicationServices.h>
#endif

// global constants
#import <DTCoreText/DTCoreTextMacros.h>
#import <DTCoreText/DTCoreTextConstants.h>
#import <DTCoreText/DTCompatibility.h>

#import <DTCoreText/DTColor+Compatibility.h>
#import <DTCoreText/DTImage+HTML.h>

// common utilities
#if TARGET_OS_IPHONE
#import <DTCoreText/DTCoreTextFunctions.h>
#endif

#import <DTCoreText/DTColorFunctions.h>

// common classes
#import <DTCoreText/DTCSSListStyle.h>
#import <DTCoreText/DTTextBlock.h>
#import <DTCoreText/DTCSSStylesheet.h>
#import <DTCoreText/DTCoreTextFontDescriptor.h>
#import <DTCoreText/DTCoreTextParagraphStyle.h>
#import <DTCoreText/DTHTMLAttributedStringBuilder.h>
#import <DTCoreText/DTHTMLElement.h>
#import <DTCoreText/DTAnchorHTMLElement.h>
#import <DTCoreText/DTBreakHTMLElement.h>
#import <DTCoreText/DTListItemHTMLElement.h>
#import <DTCoreText/DTHorizontalRuleHTMLElement.h>
#import <DTCoreText/DTStylesheetHTMLElement.h>
#import <DTCoreText/DTTextAttachmentHTMLElement.h>
#import <DTCoreText/DTTextHTMLElement.h>
#import <DTCoreText/DTHTMLWriter.h>
#import <DTCoreText/NSCharacterSet+HTML.h>
#import <DTCoreText/NSCoder+DTCompatibility.h>
#import <DTCoreText/NSDictionary+DTCoreText.h>
#import <DTCoreText/NSAttributedString+HTML.h>
#import <DTCoreText/NSAttributedString+SmallCaps.h>
#import <DTCoreText/NSAttributedString+DTCoreText.h>
#import <DTCoreText/NSMutableAttributedString+HTML.h>
#import <DTCoreText/NSMutableString+HTML.h>
#import <DTCoreText/NSScanner+HTML.h>
#import <DTCoreText/NSString+CSS.h>
#import <DTCoreText/NSString+HTML.h>
#import <DTCoreText/NSString+Paragraphs.h>
#import <DTCoreText/NSNumber+RomanNumerals.h>

// parsing classes
#import <DTCoreText/DTHTMLParserNode.h>
#import <DTCoreText/DTHTMLParserTextNode.h>

// text attachment cluster
#import <DTCoreText/DTTextAttachment.h>
#import <DTCoreText/DTDictationPlaceholderTextAttachment.h>
#import <DTCoreText/DTIframeTextAttachment.h>
#import <DTCoreText/DTImageTextAttachment.h>
#import <DTCoreText/DTObjectTextAttachment.h>
#import <DTCoreText/DTVideoTextAttachment.h>

#import <DTCoreText/NSAttributedStringRunDelegates.h>

#import <DTCoreText/DTCoreTextGlyphRun.h>
#import <DTCoreText/DTCoreTextLayoutFrame.h>
#import <DTCoreText/DTCoreTextLayoutFrame+Cursor.h>
#import <DTCoreText/DTCoreTextLayoutLine.h>
#import <DTCoreText/DTCoreTextLayouter.h>

// TARGET_OS_IPHONE is both tvOS and iOS
#if TARGET_OS_IPHONE

#import <DTCoreText/DTLazyImageView.h>
#import <DTCoreText/DTLinkButton.h>

#import <DTCoreText/DTAttributedLabel.h>
#import <DTCoreText/DTAttributedTextCell.h>
#import <DTCoreText/DTAttributedTextContentView.h>
#import <DTCoreText/DTAttributedTextView.h>
#import <DTCoreText/DTCoreTextFontCollection.h>

#import <DTCoreText/DTDictationPlaceholderView.h>

#import <DTCoreText/UIFont+DTCoreText.h>

#import <DTCoreText/DTAccessibilityElement.h>
#import <DTCoreText/DTAccessibilityViewProxy.h>
#import <DTCoreText/DTCoreTextLayoutFrameAccessibilityElementGenerator.h>

#endif
