//
//  BLCComment.m
//  Blocstagram
//
//  Created by Eric Gu on 12/28/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import "BLCComment.h"
#import "BLCUser.h"

@implementation BLCComment

 - (instancetype) initWithDictionary:(NSDictionary *)commentDictionary {
     self = [super init];
 
     if (self) {
         self.idNumber = commentDictionary[@"id"];
         self.text = commentDictionary[@"text"];
         self.from = [[BLCUser alloc] initWithDictionary:commentDictionary[@"from"]];
     }
 
     return self;
 }

@end
