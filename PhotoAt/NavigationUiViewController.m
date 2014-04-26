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
#import "FacebookManager.h"
#import "LoginViewController.h"
#import "CheckInViewController.h"

@interface NavigationUiViewController ()

@end

@implementation NavigationUiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setProfilePicture) name:ProfilePictureStored object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];

    self._profilePictureView = [[UIImageView alloc]init];
    self._profilePictureView.layer.cornerRadius = 5;
    [self.view addSubview:self._profilePictureView];
    [self setProfilePicture];
    
    self.userInfo = [[UILabel alloc]init];
    [self.view addSubview:self.userInfo];
    [self.userInfo setText:[[NSUserDefaults standardUserDefaults]
                    stringForKey:UserName]];
    [self._profilePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(10);
    }];
    
    [self.userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self._profilePictureView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    [self setDrawerListItems];

}

-(void)setDrawerListItems{

    UIButton* homeBtn       = [[UIButton alloc]init];
    UIButton* profileBtn    = [[UIButton alloc]init];
    UIButton* logOut        = [[UIButton alloc]init];
    UIButton* checkIn       = [[UIButton alloc]init];
    
    [self.view addSubview:homeBtn];
    [self.view addSubview:profileBtn];
    [self.view addSubview:logOut];
    [self.view addSubview:checkIn];
    
    [homeBtn setTitle:@"Home" forState:UIControlStateNormal];
    [profileBtn setTitle:@"Profile" forState:UIControlStateNormal];
    [logOut setTitle:@"Logout" forState:UIControlStateNormal];
    [checkIn setTitle:@"CheckIn" forState:UIControlStateNormal];
    
    [homeBtn setBackgroundColor:[UIColor blueColor]];
    [profileBtn setBackgroundColor:[UIColor blueColor]];
    [logOut setBackgroundColor:[UIColor blueColor]];
    [checkIn setBackgroundColor:[UIColor redColor]];
    
    [homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.equalTo(@50);
        make.top.equalTo(self._profilePictureView.mas_bottom).with.offset(40);
    }];
    
    [profileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view);
         make.width.equalTo(self.view.mas_width).multipliedBy(0.9);
         make.height.equalTo(@50);
         make.top.equalTo(homeBtn.mas_bottom).with.offset(10);
    }];
    
    [logOut mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view);
         make.width.equalTo(self.view.mas_width).multipliedBy(0.9);
         make.height.equalTo(@50);
         make.top.equalTo(profileBtn.mas_bottom).with.offset(10);
    }];
    
    [checkIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.equalTo(@50);
        make.top.equalTo(logOut.mas_bottom).with.offset(10);
    }];
    
    [homeBtn addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
    [logOut addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [profileBtn addTarget:self action:@selector(goToProfile) forControlEvents:UIControlEventTouchDragInside];
    [checkIn addTarget:self action:@selector(checkIn) forControlEvents:UIControlEventTouchDragInside];

}

-(void)logOut{
    [[FacebookManager facebookManager] logOutUser];
    LoginViewController* loginViewController = [[LoginViewController alloc]init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

-(void)checkIn{
    CheckInViewController* checkInViewController = [CheckInViewController new];
    [self presentViewController:checkInViewController animated:YES completion:nil];

}

-(void)goToProfile{

}
-(void)goToHome{

    [[FacebookManager facebookManager] facebookPlaces];

}

-(void)setProfilePicture{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:ProfilePicture];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    [self._profilePictureView setImage:img];
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
