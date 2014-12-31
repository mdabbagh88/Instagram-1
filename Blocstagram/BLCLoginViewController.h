//
//  BLCLoginViewController.h
//  Blocstagram
//
//  Created by Eric Gu on 12/30/14.
//  Copyright (c) 2014 egu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCLoginViewController : UIViewController

//An access token is like a password, just for our app: it's a string that encodes security credentials for a user's Instagram account.
//extern = GLOBAL CONSTANT which is the opposite of STATIC
//All classes can be notified when access token is obtained.

extern NSString *const BLCLoginViewControllerDidGetAccessTokenNotification;


@end
