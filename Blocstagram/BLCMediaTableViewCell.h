//
//  BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Eric Gu on 12/29/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCMedia.h"

@interface BLCMediaTableViewCell : UITableViewCell

// Get the media item
- ( BLCMedia * )mediaItem;

// Set a new media item
- ( void )setMediaItem:( BLCMedia * )mediaItem;
+ ( CGFloat ) heightForMediaItem:( BLCMedia * )mediaItem width:( CGFloat )width;
@end
