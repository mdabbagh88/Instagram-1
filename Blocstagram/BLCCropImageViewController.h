//
//  BLCCropImageViewController.h
//  Blocstagram
//
//  Created by Eric Gu on 1/8/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import "BLCMediaFullScreenViewController.h"

@class BLCCropImageViewController;

@protocol BLCCropImageViewControllerDelegate <NSObject>

- ( void ) cropControllerFinishedWithImage:( UIImage * )croppedImage;

@end

@interface BLCCropImageViewController : BLCMediaFullScreenViewController

- ( instancetype ) initWithImage:( UIImage * )sourceImage;

@property ( nonatomic, weak ) NSObject <BLCCropImageViewControllerDelegate> *delegate;

@end
