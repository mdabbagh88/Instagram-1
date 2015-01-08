//
//  BLCCameraViewController.h
//  Blocstagram
//
//  Created by Eric Gu on 1/8/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCCameraViewController;
 
@protocol BLCCameraViewControllerDelegate <NSObject>
 
- ( void ) cameraViewController:( BLCCameraViewController * )cameraViewController didCompleteWithImage:( UIImage * )image;
 
@end
 
@interface BLCCameraViewController : UIViewController

@property ( nonatomic, weak ) NSObject <BLCCameraViewControllerDelegate> *delegate;
 
 @end
