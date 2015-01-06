//
//  BLCLikeButton.h
//  Blocstagram
//
//  Created by Eric Gu on 1/5/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCMedia;

typedef NS_ENUM( NSInteger, BLCLikeState )
{
  BLCLikeStateNotLiked             = 0,
  BLCLikeStateLiking               = 1,
  BLCLikeStateLiked                = 2,
  BLCLikeStateUnliking             = 3
};

@interface BLCLikeButton : UIButton

@property ( nonatomic, assign ) BLCLikeState likeButtonState;

@end
