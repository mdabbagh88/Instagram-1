//
//  BLCMediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Eric Gu on 1/3/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCMedia;

@interface BLCMediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
 
- ( instancetype ) initWithMedia:(BLCMedia *)media;
- ( void ) centerScrollView;

@end
