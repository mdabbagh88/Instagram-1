//
//  BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Eric Gu on 12/29/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import <UIKit/UIKit.h>
//BLCMedia was imported, not a class? This is confusing!
@class BLCMedia, BLCMediaTableViewCell, BLCComposeCommentView;

@protocol BLCMediaTableViewCellDelegate <NSObject>

- ( void ) cell: ( BLCMediaTableViewCell * )cell didTapImageView:( UIImageView *)imageView;
- ( void ) cell: ( BLCMediaTableViewCell * )cell didDoubleTapImageView:( UIImageView *)imageView;
- ( void ) cell: ( BLCMediaTableViewCell * )cell didLongPressImageView:( UIImageView *)imageView;
- ( void ) cellDidPressLikeButton:(BLCMediaTableViewCell *)cell;

- ( void ) cellWillStartComposingComment:( BLCMediaTableViewCell * )cell;
- ( void ) cell:( BLCMediaTableViewCell * )cell didComposeComment:( NSString * )comment;

@end

@interface BLCMediaTableViewCell : UITableViewCell

//This was never a property before? This is confusing!
@property ( nonatomic, strong ) BLCMedia *mediaItem;
@property ( nonatomic, strong ) id <BLCMediaTableViewCellDelegate> delegate;
@property ( nonatomic, strong, readonly ) BLCComposeCommentView *commentView;

// Get the media item
- ( BLCMedia * )mediaItem;

// Set a new media item
- ( void )setMediaItem:( BLCMedia * )mediaItem;
+ ( CGFloat ) heightForMediaItem:( BLCMedia * )mediaItem width:( CGFloat )width;

- ( void ) stopComposingComment;

@end
