//
//  BLCMedia.h
//  Blocstagram
//
//  Created by Eric Gu on 12/28/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BLCUser;

@interface BLCMedia : NSObject

@property ( nonatomic, strong ) NSString *idNumber;
@property ( nonatomic, strong ) BLCUser *user;
@property ( nonatomic, strong ) NSURL *mediaURL;
@property ( nonatomic, strong ) UIImage *image;
@property ( nonatomic, strong ) NSString *caption;
@property ( nonatomic, strong ) NSArray *comments;

@end