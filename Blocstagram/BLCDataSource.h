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

+ ( instancetype ) sharedInstance;

+ ( NSString * ) instagramClientID;

@property ( nonatomic, strong, readonly ) NSMutableArray *mediaItems;
@property (nonatomic, strong, readonly) NSString *accessToken;

- ( void ) deleteMediaItem:(BLCMedia *)item;
- ( void ) requestNewItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler;
- ( void ) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler;

@end
