//
//  FacebookManager.h
//  PhotoAt
//
//  Created by Finki Finki on 4/25/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookManager : NSObject
@property (nonatomic, retain) NSArray* permissions;
@property (nonatomic, retain) NSMutableData* imageData;
+(id)facebookManager;

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState )state error:(NSError *)error;
-(BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
-(BOOL)isUserLoggedIn;
-(void)attemptToLogIn;
-(void)logOutUser;
-(void)checkForCachedToken;
- (void)facebookPlaces;
@end
