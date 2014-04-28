//
//  FacebookManager.m
//  PhotoAt
//
//  Created by Finki Finki on 4/25/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookManager

@synthesize user;

-(id)init{
    self = [super init];
    
    if (self) {
        [FBLoginView class];
        self.permissions = [[NSArray alloc]initWithObjects:@"basic_info",@"user_location", nil];
    }
    return self;
}

-(void)storeFacebookProfilePicture{
    FBProfilePictureView* profilePic = [[FBProfilePictureView alloc]init];
    
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
         if (error) {
             // Handle error
         }
         else {
             self.user = FBuser;
             profilePic.profileID = FBuser.id;
             [[NSUserDefaults standardUserDefaults]
              setObject:FBuser.name forKey:UserName];
         }
     }];
}


-(NSString*)getUserName{
    return [self.user name];
}
-(NSString *)getId{
    return [self.user id];
}

+(id)facebookManager{
    static FacebookManager* facebookManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        facebookManager = [[self alloc]init];
    });
    return facebookManager;
}

- (void)facebookPlaces {
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.title = @"Nearby Places";
    NSString *placeName = placePickerController.selection.name;
    if (!placeName) {
        placeName = @"<No Place Selected>";
    }
    // This grabs the long and lat of each place selected:
    NSString *firstLat = [[NSString alloc] initWithFormat:@"%f", placePickerController.locationCoordinate.latitude];
    NSLog(@"First Lat: %@", firstLat);
    NSString *firstLong = [[NSString alloc] initWithFormat:@"%f", placePickerController.locationCoordinate.longitude];
    NSLog(@"First Long: %@", firstLong);
}



-(void)checkForCachedToken{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSessionWithUI:NO];
    }
    //if there is no chached Session do nothing
}

-(void)attemptToLogIn{
    [self openSessionWithUI:YES];
}

-(void)logOutUser{
    // If the session state is any of the two "open" states
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Close the session and remove the access token from the cache
        [FBSession.activeSession closeAndClearTokenInformation];
        
    }
}


-(void)openSessionWithUI:(BOOL)showUI{
    [FBSession openActiveSessionWithReadPermissions:self.permissions
                                       allowLoginUI:showUI
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
}

-(BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

-(BOOL)isUserLoggedIn{
    return FBSession.activeSession.isOpen;
}

-(void) userLoggedIn{
    [self storeFacebookProfilePicture];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserSucessfullyLogedIn object:nil];
}

-(void) userLoggedOut{
    //TODO LogOutUser
}

-(void)showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle{
    //TODO SHOW alert!
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}


@end