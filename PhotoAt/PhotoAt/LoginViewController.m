//
//  LoginViewController.m
//  PhotoAt
//
//  Created by Finki Finki on 4/23/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginAppDelegate.h"
#import "FacebookManager.h"
#import "DrawerViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

-(id)init{
    
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucessfulllLogIn) name:UserSucessfullyLogedIn object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIButton* loginView = [UIButton new];
    [loginView setTitle:@"Login WithFacebook" forState:UIControlStateNormal];
    [loginView addTarget:self action:@selector(loginUser) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:loginView];
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@250);
        make.height.equalTo(@50);
        make.center.equalTo(self.view);
    }];
}

- (void)loginUser{
    [[FacebookManager facebookManager] attemptToLogIn];
}

- (void)sucessfulllLogIn{
    [self loginUserWithParse];
     DrawerViewController* homeController = [[DrawerViewController alloc]init];
    UINavigationController* navController = [[UINavigationController alloc]initWithRootViewController:homeController];
   
    
    [self presentViewController:navController animated:YES completion:nil];
}


-(void)loginUserWithParse{
    PFUser *userObject = [PFUser objectWithClassName:userClass];
    userObject[userObjectId] =[[FacebookManager facebookManager] getId];
    userObject[userUsername] = [[FacebookManager facebookManager] getUserName];
    [userObject saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
