//
//  BLCDatasource.m
//  Blocstagram
//
//  Created by Eric Gu on 12/29/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import "BLCDatasource.h"

@interface BLCDatasource ( )

@property ( nonatomic, strong ) NSArray *mediaItems;

@end

@implementation BLCDatasource

+ ( instancetype ) sharedInstance
{
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
      sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}
@end
