//
//  BLCDatasource.h
//  Blocstagram
//
//  Created by Eric Gu on 12/29/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

@class BLCMedia;
#import <Foundation/Foundation.h>
#import <UICKeyChainStore.h>

typedef void ( ^BLCNewItemCompletionBlock )( NSError *error );

@interface BLCDataSource : NSObject

@property ( nonatomic, strong, readonly ) NSMutableArray *mediaItems;
@property (nonatomic, strong, readonly) NSString *accessToken;

+ ( instancetype ) sharedInstance;
+ ( NSString * ) instagramClientID;

- ( void ) deleteMediaItem:(BLCMedia *)item;
- ( void ) requestNewItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler;
- ( void ) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler;
@end
