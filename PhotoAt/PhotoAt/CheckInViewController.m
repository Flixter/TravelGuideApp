//
//  CheckInViewController.m
//  PhotoAt
//
//  Created by Finki Finki on 4/26/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "CheckInViewController.h"
#import "CustomRatingView.h"
#import "FacebookManager.h"

#define kLabelAllowance 50.0f
#define kStarViewHeight 30.0f
#define kStarViewWidth 160.0f
#define kLeftPadding 5.0f

@interface CheckInViewController ()

@end

@implementation CheckInViewController


- (void)viewDidLoad
{

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(upload)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [super viewDidLoad];
	[self setUpViews];

}

-(void)upload{

//    PFUser *picturesObject = [PFUser objectWithClassName:userClass];
//    userObject[userObjectId] =[[FacebookManager facebookManager] getId];
//    userObject[userUsername] = [[FacebookManager facebookManager] getUserName];
//    [userObject saveInBackground];
    
    PFObject *picturesObject = [PFObject objectWithClassName:picturesClass];
    //TODO change to id
    picturesObject[picturesOwner]   = [[FacebookManager facebookManager] getUserName];
    picturesObject[picturesComment] = [self.comment text];
    picturesObject[picturesCheckIn] = [[self.checkIn titleLabel] text];
    //picturesObject[picturesPicture] = [self.takenImage image];
    NSData* data = UIImageJPEGRepresentation(self.takenImage.image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    // Save the image to Parse
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            [picturesObject setObject:imageFile forKey:picturesPicture];
            
            [picturesObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
    [picturesObject saveInBackground];
}

-(void)keyboardWillShow {
	// Animate the current view out of the way
    [UIView animateWithDuration:0.3f animations:^ {
        self.view.frame = CGRectMake(0, -210, 320, 480);
        
    }];
}

-(void)keyboardWillHide {
	// Animate the current view back to its original position
    [UIView animateWithDuration:0.3f animations:^ {
        self.view.frame = CGRectMake(0, 0, 320, 480);
    }];
}

-(void)setUpViews{
    
    
    self.takenImage = [UIImageView new];
    UIView* rView = [UIView new];
    self.checkIn = [UIButton new];
    self.comment    = [[UITextField alloc]init];
    
    [self.view addSubview: self.takenImage];
    [self.view addSubview: self.checkIn];
    [self.view addSubview: self.comment];
    [self.view addSubview:rView];
   

    [rView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.1);
        make.top.equalTo(self.takenImage.mas_bottom);
        make.left.equalTo(self.view);
    }];
    
    //TODO Calculate half
    CustomRatingView* ratingView = [[CustomRatingView alloc]initWithFrame:CGRectMake(80, 0, kStarViewWidth+kLeftPadding, kStarViewHeight) andRating:0 withLabel:NO animated:YES];
    [rView addSubview: ratingView];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    singleTap.numberOfTapsRequired = 1;
    self.takenImage.userInteractionEnabled = YES;
    [self.takenImage addGestureRecognizer:singleTap];
    [self.takenImage setBackgroundColor:[UIColor purpleColor]];
    [self.takenImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.7);
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    //Setup CheckIn Button
    [self.checkIn setTitle:@"Select Place to check in" forState:UIControlStateNormal];
    [self.checkIn setBackgroundColor:[UIColor cyanColor]];
    [self.checkIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.1);
        make.top.equalTo(rView.mas_bottom);
        make.left.equalTo(self.view);
    }];
    [self.checkIn addTarget:self action:@selector(presentNearByPlaces)
      forControlEvents:UIControlEventTouchUpInside];

    [self.comment setBackgroundColor:[UIColor brownColor]];
    self.comment.placeholder = @"Leave a comment for this place";
    self.comment.delegate = self;
    [self.comment setReturnKeyType:UIReturnKeyDone];
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.1);
        make.top.equalTo(self.checkIn.mas_bottom);
        make.left.equalTo(self.view);
    }];
    
    
}

-(void)chooseImage{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate= self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)presentNearByPlaces{
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.delegate = self;
    placePickerController.title = @"Nearby Places";
    placePickerController.radiusInMeters = 1000;
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(42.0045871, 21.4083986);
    [placePickerController loadData];
    [self presentViewController:placePickerController animated:YES completion:nil];
}

-(void)facebookViewControllerCancelWasPressed:(id)sender{
    NSLog(@"CANCEL");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)facebookViewControllerDoneWasPressed:(id)sender{
    NSLog(@"Done");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.takenImage setImage:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)placePickerViewControllerSelectionDidChange:(FBPlacePickerViewController *)placePicker{
    NSLog(@"Location Selected :%@",placePicker.selection.name);
    if(placePicker.selection.name)
    [self.checkIn setTitle:placePicker.selection.name forState:UIControlStateNormal];
    else
   [self.checkIn setTitle:@"Select Place to check in" forState:UIControlStateNormal];
}

@end
