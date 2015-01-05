//
//  BLCMedia.h
//  Blocstagram
//
//  Created by Eric Gu on 12/28/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLCMediaDownloadState)
{
  BLCMediaDownloadStateNeedsImage = 0,
  BLCMediaDownloadStateDownloadInProgress = 1,
  BLCMediaDownloadStateNonRecoverableError = 2,
  BLCMediaDownloadStateHasImage = 3
};

@class BLCUser;

@interface BLCMedia : NSObject <NSCoding>

@property ( nonatomic, strong ) NSString *idNumber;
@property ( nonatomic, strong ) BLCUser *user;
@property ( nonatomic, strong ) NSURL *mediaURL;
@property ( nonatomic, strong ) UIImage *image;
@property ( nonatomic, strong ) NSString *caption;
@property ( nonatomic, strong ) NSArray *comments;
@property ( nonatomic, assign ) BLCMediaDownloadState downloadState;

- ( instancetype ) initWithDictionary:( NSDictionary * )mediaDictionary;

@end
