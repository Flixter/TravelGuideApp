//
//  CheckInViewController.m
//  PhotoAt
//
//  Created by Finki Finki on 4/26/14.
//  Copyright (c) 2014 Finki. All rights reserved.
//

#import "CheckInViewController.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setUpViews];
    
}

-(void)setUpViews{

    self.nearByPlaces = [[UIButton alloc]init];
    [self.nearByPlaces setTitle:@"Show Near By Places" forState:UIControlStateNormal];
    [self.nearByPlaces setBackgroundColor:[UIColor redColor]];
    [self.view addSubview: self.nearByPlaces];
    
    [self.nearByPlaces mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.equalTo(@70);
        make.center.equalTo(self.view);
    }];

    [self.nearByPlaces addTarget:self action:@selector(presentNearByPlaces) forControlEvents:UIControlEventTouchUpInside];
}

-(void)presentNearByPlaces{
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    placePickerController.delegate = self;
    placePickerController.title = @"Nearby Places";
    placePickerController.radiusInMeters = 1000;
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(25.047723, 121.450088);
    [placePickerController loadData];
    [self presentViewController:placePickerController animated:YES completion:nil];
}

-(void)facebookViewControllerCancelWasPressed:(id)sender{
    NSLog(@"CANCEL");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)facebookViewControllerDoneWasPressed:(id)sender{
    NSLog(@"Done");
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)placePickerViewControllerSelectionDidChange:(FBPlacePickerViewController *)placePicker{
    NSLog(@"Location Selected :%@",placePicker.selection.name);
}

@end
