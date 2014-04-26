//
//  DrawerViewController.m
//  PhotoAt
//
//  Created by Finki Finki on 4/25/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "DrawerViewController.h"
#import "NavigationUiViewController.h"
#import "CenterViewController.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (id)init
{
    self = [super init];
    if (self) {
        UIViewController * leftSideDrawerViewController = [[NavigationUiViewController alloc] init];
        UIViewController * centerViewController = [[CenterViewController alloc] init];
        
        self = [[MMDrawerController alloc]
                                 initWithCenterViewController:centerViewController
                                 leftDrawerViewController:leftSideDrawerViewController
                                 rightDrawerViewController:nil];
        
        [self setMaximumRightDrawerWidth:200.0];
        [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
