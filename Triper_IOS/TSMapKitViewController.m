//
//  TSMapKitViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMapKitViewController.h"
#import "TSServerManager.h"
#import "TSRetriveFriendsFBDatabase.h"
#import "TSFireUser.h"
#import "TSTabBarController.h"
#import "TSRetriveFriendsFBDatabase.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@import Firebase;
@import FirebaseDatabase;

@class MKMapView;

static NSInteger tag = 0;

@interface TSMapKitViewController () <MKMapViewDelegate, CLLocationManagerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *cityes;
@property (strong, nonatomic) NSMutableArray *IDs;
@property (strong, nonatomic) NSMutableArray *avatars;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (assign, nonatomic) NSInteger counterMap;

@end

@implementation TSMapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    [self.locationManager requestAlwaysAuthorization];

    self.mapView.delegate = self;
    
    self.friends = [NSMutableArray array];
    self.IDs = [NSMutableArray array];
    self.avatars = [NSMutableArray array];
    self.cityes = [NSMutableArray array];
    
    
    self.ref = [[FIRDatabase database] reference];
    
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.friends = [TSRetriveFriendsFBDatabase retriveFriendsDatabase:snapshot];
        
        for (int i = 0; i < self.friends.count; i++) {
            
            
            NSDictionary *pair = [self.friends objectAtIndex:i];
            NSString *city = [pair objectForKey:@"city"];
            
            if (![city isEqualToString:@""]) {
                
                NSString *avatarURL = [pair objectForKey:@"photoURL"];
                NSString *ID = [pair objectForKey:@"fireUserID"];
                
                NSDictionary *friend = @{@"city":city,
                                         @"avatarURL":avatarURL,
                                         @"ID":ID};
                [self.cityes addObject:friend];
                
            }
        }
    }];
    
    
    if (self.cityes != nil) {
        
        for (NSString *city in self.cityes) {
            
            MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
            request.naturalLanguageQuery = city;
            request.region = self.mapView.region;
            
            MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
            
            [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
             {
                 NSMutableArray *placemarks = [NSMutableArray array];
                 for (MKMapItem *item in response.mapItems) {
                     [placemarks addObject:item.placemark];
                 }
                 [self.mapView showAnnotations:placemarks animated:NO];
             }];
        }
    }
    
    
//    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        
//        FIRUser *currentID = [FIRAuth auth].currentUser;
//        NSString *key = [NSString stringWithFormat:@"users/%@/friends", currentID.uid];
//        FIRDataSnapshot *dataFriends = [snapshot childSnapshotForPath:key];
//        
//        for (int i = 0; i < dataFriends.childrenCount; i++) {
//            
//            NSString *key = [NSString stringWithFormat:@"key%d", i];
//            NSDictionary *pair = dataFriends.value[key];
//            NSString *avatarURL = [pair objectForKey:@"photoURL"];
//            NSString *ID = [pair objectForKey:@"fireUserID"];
//            [self.avatars addObject:avatarURL];
//            [self.IDs addObject:ID];
//        }
//        
//    }];
//    
    self.counterMap = 0;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"locations = %@", [locations lastObject]);
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    NSLog(@"userLocation = %@", userLocation.location);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        pinView.frame = CGRectMake(0, 0, 40, 40);
        pinView.canShowCallout = YES;
        
        
        UIImageView *imgView = nil;
        
        if (tag < self.cityes.count) {
            
            NSDictionary *pair = [self.cityes objectAtIndex:tag];
            
            NSString *avatarURL = [pair objectForKey:@"photoURL"];
            
            NSURL *urlImage = [NSURL URLWithString:avatarURL];
            NSData *dataUrl = [NSData dataWithContentsOfURL:urlImage];
            UIImage *image = [UIImage imageWithData:dataUrl];
            imgView = [[UIImageView alloc] initWithImage:image];
            imgView.frame = pinView.frame;
            imgView.layer.cornerRadius = imgView.frame.size.width / 2;
            imgView.layer.masksToBounds = YES;
        }
        
        [pinView addSubview:imgView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:pinView.frame];
        
        NSInteger max = self.cityes.count;
        
        if (tag < max) {
            button.tag = tag;
            ++tag;
        }
        
        [pinView addSubview:button];
        [button addTarget:self action:@selector(actionAnnotation:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"TAG %ld", tag);
    }
    else {
        [mapView.userLocation setTitle:@"I am here"];

    }
    
    if (self.counterMap == 0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self centerMapOnLocation];
        });
        ++self.counterMap;
    }
    
    return pinView;
}


- (void)actionAnnotation:(UIButton *)button
{
    
    TSTabBarController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarController"];
    [self presentViewController:controller animated:YES completion:nil];
    controller.selectedIndex = 3;
    NSDictionary *pair = [self.friends objectAtIndex:button.tag];
    NSString *userID = [pair objectForKey:@"fireUserID"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeOnTheMethodCall" object:userID];
    
    NSLog(@"SENDER %ld", button.tag);
    
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}


- (void)centerMapOnLocation
{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:46.345988 longitude:12.430988];
    double regionRadius = 488000.00;
    
    MKCoordinateRegion viewRegion =
    MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 8.0, regionRadius * 8.0);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
