//
//  BLCMediaFullScreenAnimator.h
//  Blocstagram
//
//  Created by Eric Gu on 1/3/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <Foundation/Foundation.h>
//missing import statement UIKit
#import <UIKit/UIKit.h>

@interface BLCMediaFullScreenAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property ( nonatomic, assign ) BOOL presenting;
@property ( nonatomic, weak ) UIImageView *cellImageView;

@end
