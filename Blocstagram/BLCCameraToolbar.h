//
//  BLCCameraToolbar.h
//  Blocstagram
//
//  Created by Eric Gu on 1/8/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCCameraToolbar;

@protocol BLCCameraToolbarDelegate <NSObject>
 
- ( void ) leftButtonPressedOnToolbar:( BLCCameraToolbar * )toolbar;
- ( void ) rightButtonPressedOnToolbar:( BLCCameraToolbar * )toolbar;
- ( void ) cameraButtonPressedOnToolbar:( BLCCameraToolbar * )toolbar;
 
@end

@interface BLCCameraToolbar : UIView

@property ( nonatomic, weak ) NSObject <BLCCameraToolbarDelegate> *delegate;

- ( instancetype ) initWithImageNames:( NSArray * )imageNames;

@end
