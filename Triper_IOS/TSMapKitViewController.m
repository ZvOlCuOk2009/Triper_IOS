//
//  TSMapKitViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMapKitViewController.h"
#import <MapKit/MapKit.h>

@class MKMapView;

@interface TSMapKitViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation TSMapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startLocationManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude=13.04016;
    myCoordinate.longitude=80.243044;
    annotation.coordinate = myCoordinate;
    [self.mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
     NSLog(@"mapViewWillStartLoadingMap");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
     NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization]; // Add This Line
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
