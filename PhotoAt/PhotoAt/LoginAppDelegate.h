//
//  LoginAppDelegate.h
//  PhotoAt
//
//  Created by Finki Finki on 4/23/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationUiViewController.h"
#import <MMDrawerController.h>
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "CenterViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) MMDrawerController * drawerController;

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
