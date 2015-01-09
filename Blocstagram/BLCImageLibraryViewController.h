//
//  BLCImageLibraryViewController.h
//  Blocstagram
//
//  Created by Eric Gu on 1/8/15.
//  Copyright (c) 2015 egu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCImageLibraryViewController;
 
@protocol BLCImageLibraryViewControllerDelegate <NSObject>
 
- ( void ) imageLibraryViewController:( BLCImageLibraryViewController * )imageLibraryViewController didCompleteWithImage:( UIImage * )image;
 
@end
 
@interface BLCImageLibraryViewController : UICollectionViewController
 
@property ( nonatomic, weak ) NSObject <BLCImageLibraryViewControllerDelegate> *delegate;

@end