//
//  BLCDatasource.h
//  Blocstagram
//
//  Created by Eric Gu on 12/29/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

@class BLCMedia;
#import <Foundation/Foundation.h>

@interface BLCDataSource : NSObject

+( instancetype ) sharedInstance;

@property ( nonatomic, strong, readonly ) NSMutableArray *mediaItems;

 - (void) deleteMediaItem:(BLCMedia *)item;
@end
