//
//  LoginAppDelegate.m
//  PhotoAt
//
//  Created by Finki Finki on 4/23/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "LoginAppDelegate.h"
#import "LoginViewController.h"
#import "FacebookManager.h"

@implementation LoginAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Load the FbLoginView Class
    [Parse setApplicationId:parseId
                  clientKey:parseClientKey];

    [[FacebookManager facebookManager] checkForCachedToken];
    [self setRootViewController];
    return YES;
}

-(void)setRootViewController{
    BOOL isUserLoggedIn =[[FacebookManager facebookManager] isUserLoggedIn];
    if(isUserLoggedIn){
        [self setUpHomeNavigation];
    }else{
        [self.window setRootViewController:[[LoginViewController alloc]init]];
    }
}

-(void)setUpHomeNavigation{
    
    DrawerViewController* drawerViewController = [[DrawerViewController alloc]init];
    [self.window setRootViewController: drawerViewController];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    return wasHandled;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    // Whenever a person opens the app, check for a cached session

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
