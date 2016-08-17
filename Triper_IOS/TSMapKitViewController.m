//
//  TSMapKitViewController.m
//  Triper_IOS
//
//  Created by Mac on 08.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSMapKitViewController.h"
#import "TSServerManager.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class MKMapView;

@interface TSMapKitViewController () <MKMapViewDelegate, CLLocationManagerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *friendLocation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sender;

@end

@implementation TSMapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startLocationManager];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    [self.locationManager requestAlwaysAuthorization];
    
    
//    CLLocationCoordinate2D coordinate;
//    double latitude = 40.8934;
//    double longtitude = 80.243044;
//    coordinate.latitude = latitude;
//    coordinate.longitude = longtitude;
//    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
//    myAnnotation.coordinate = coordinate;
//    myAnnotation.title = @"Булавка 1";
//    myAnnotation.subtitle = @"Булавка 1";
//    [self.mapView addAnnotation:myAnnotation];

    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = 50.27;
    pinCoordinate.longitude = 30.30;
    myAnnotation.coordinate = pinCoordinate;
    
    myAnnotation.title = @"MD";
    myAnnotation.subtitle = @"McDonalds";
    
    [self.mapView addAnnotation:myAnnotation];
    
    MKPointAnnotation *myAnnotation2 = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D pinCoordinate2;
    pinCoordinate2.latitude = 47.27;
    pinCoordinate2.longitude = 31.30;
    myAnnotation2.coordinate = pinCoordinate2;
    
    myAnnotation2.title = @"Matthews Pizza";
    myAnnotation2.subtitle = @"Best Pizza in Town";
    
    [self.mapView addAnnotation:myAnnotation2];
    
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
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 23, 23);
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [button setImage:[UIImage imageNamed:@"av4"] forState:UIControlStateNormal];
    
    
    annotationView.rightCalloutAccessoryView = button;
    
    
    // Image and two labels
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"av5"]];
    
    UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
    [leftCAV addSubview:imgView];
    annotationView.leftCalloutAccessoryView = imgView;
    
    annotationView.canShowCallout = YES;
    
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Pizza Shop");
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Disclosure Pressed"
                                                                              message:@"Click Cancel to Go Back"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                          
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Cencel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }];
    [alertController addAction:actionYes];
    [alertController addAction:actionNo];
    [self presentViewController:alertController animated:YES completion:nil];
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
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}


#pragma mark - IBAction


- (IBAction)setMap:(id)sender
{
    switch (((UISegmentedControl *) sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
    }
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
