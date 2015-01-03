//
//  BLCComment.h
//  Blocstagram
//
//  Created by Eric Gu on 12/28/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLCUser;

@interface BLCComment : NSObject <NSCoding>

@property ( nonatomic, strong ) NSString *idNumber;
@property ( nonatomic, strong ) NSString *text;
@property ( nonatomic, strong ) BLCUser *from;

 - (instancetype) initWithDictionary:(NSDictionary *)commentDictionary;
 
@end
