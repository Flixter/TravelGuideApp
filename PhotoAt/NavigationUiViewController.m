//
//  NavigationUiViewController.m
//  PhotoAt
//
//  Created by Finki Finki on 4/23/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "NavigationUiViewController.h"
#import <Masonry.h>
#import <QuartzCore/QuartzCore.h>

@interface NavigationUiViewController ()

@end

@implementation NavigationUiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];

    FBProfilePictureView* _profilePictureView = [[FBProfilePictureView alloc]init];
    _profilePictureView.layer.cornerRadius = 5;
    [self.view addSubview:_profilePictureView];
    
    UILabel* userInfo = [[UILabel alloc]init];
    [self.view addSubview:userInfo];
    
    [_profilePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(10);
    }];
    
    [userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_profilePictureView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            // Handle error
        }
        
        else {
            [userInfo setText: FBuser.name];
            _profilePictureView.profileID = FBuser.id;
            
        }
    }];
    
	// Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
