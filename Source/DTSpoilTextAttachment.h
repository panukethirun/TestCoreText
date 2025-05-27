//
//  DTSpoilTextAttachment.h
//  ASKBook
//
//  Created by Developer Meb on 9/13/18.
//

#import "DTCoreText.h"
#import <UIKit/UIKit.h>
#import "DTRichTextEditor.h"
//#import <DTRichTextEditor.h>
/**
 A specialized subclass in the DTTextAttachment class cluster to represent an SPOIL
 */

@interface DTSpoilTextAttachment : DTTextAttachment <DTTextAttachmentHTMLPersistence , DTRichTextEditorViewDelegate, DTAttributedTextContentViewDelegate> {
    NSAttributedString *spoilText;
}
@property(nonatomic,readwrite) NSAttributedString *spoilText;
@end
