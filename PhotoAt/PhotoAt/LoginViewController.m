//
//  LoginViewController.m
//  PhotoAt
//
//  Created by Finki Finki on 4/23/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry.h>
#import "LoginAppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions:
     @[@"basic_info"]];
    
    loginView.delegate = self;
    
    [self.view addSubview:loginView];
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    LoginAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil];
    [self loginUserWithParse:user];
}


-(void)loginUserWithParse:(id<FBGraphUser>)user{
    PFUser *testObject = [PFUser objectWithClassName:userClass];
    testObject[userObjectId] = user.id;
    testObject[userUsername] = user.name;
    testObject[userPassword] = @"Password";
    [testObject saveInBackground];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
