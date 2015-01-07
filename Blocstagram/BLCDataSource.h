//
//  BLCDatasource.h
//  Blocstagram
//
//  Created by Eric Gu on 12/29/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

@class BLCMedia;
#import <Foundation/Foundation.h>


typedef void ( ^BLCNewItemCompletionBlock )( NSError *error );

@interface BLCDataSource : NSObject

@property ( nonatomic, strong, readonly ) NSArray *mediaItems;
@property ( nonatomic, strong, readonly ) NSString *accessToken;

+ ( instancetype ) sharedInstance;
+ ( NSString * ) instagramClientID;

- ( void ) deleteMediaItem:( BLCMedia * )item;
- ( void ) requestNewItemsWithCompletionHandler:( BLCNewItemCompletionBlock )completionHandler;
- ( void ) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlock )completionHandler;
- ( void ) downloadImageForMediaItem:( BLCMedia * )mediaItem;
- ( void ) toggleLikeOnMediaItem:(BLCMedia *)mediaItem;
- ( void ) commentOnMediaItem:(BLCMedia *)mediaItem withCommentText:(NSString *)commentText;
@end
