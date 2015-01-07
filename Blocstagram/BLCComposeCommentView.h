//
//  BLCComposeCommentView.h
//  Blocstagram
//
//  Created by Eric Gu on 1/7/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCComposeCommentView;

@protocol BLCComposeCommentViewDelegate <NSObject>

- ( void ) commentViewDidPressCommentButton:( BLCComposeCommentView * )sender;
- ( void ) commentView:( BLCComposeCommentView * )sender textDidChange:(NSString *)text;
- ( void ) commentViewWillStartEditing: (BLCComposeCommentView * )sender;

@end

@interface BLCComposeCommentView : UIView

@property ( nonatomic, weak ) NSObject <BLCComposeCommentViewDelegate> *delegate;
@property ( nonatomic, assign ) BOOL isWritingComment;
@property ( nonatomic, strong ) NSString *text;
 
- ( void ) stopComposingComment;

@end
