//
//  CheckInViewController.h
//  PhotoAt
//
//  Created by Finki Finki on 4/26/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface CheckInViewController : UIViewController <FBPlacePickerDelegate, FBViewControllerDelegate>

@property (nonatomic, retain) UIButton* nearByPlaces;

@end
