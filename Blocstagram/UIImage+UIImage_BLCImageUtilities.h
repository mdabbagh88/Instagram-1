//
//  UIImage+UIImage_BLCImageUtilities.h
//  Blocstagram
//
//  Created by Eric Gu on 1/8/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_BLCImageUtilities)

- ( UIImage * ) imageByScalingToSize:( CGSize )size andCroppingWithRect:( CGRect )rect;

@end
