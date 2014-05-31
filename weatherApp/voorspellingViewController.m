//
//  voorspellingViewController.m
//  weatherApp
//
//  Created by Sinove on 28/05/14.
//  Copyright (c) 2014 Sinove. All rights reserved.
//

#import "voorspellingViewController.h"
#import "tabbarViewController.h"
@interface voorspellingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *locatie;
@property (weak, nonatomic) IBOutlet UILabel *tempMinD1;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxD1;
@property (weak, nonatomic) IBOutlet UILabel *tempMinD2;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxD2;
@property (weak, nonatomic) IBOutlet UILabel *tempMinD3;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxD3;

@end

@implementation voorspellingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    location=[locationManager location];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    static int counter =299;
    counter++;
    location = newLocation; // locations is guaranteed to have at least one object
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    
    
    if (counter == 300 ) {
        
        [self getWeatherFromTheFuture];
        NSLog(@"%.8f",latitude);
        NSLog(@"%.8f",longitude);
        counter = 0;
    }
    
}



- (void) getWeatherFromTheFuture
{
    int days = 3;
    
    NSString * URI = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%.8f&lon=%.8f&cnt=%d&mode=json", latitude,longitude,days];
    
    NSURLSession *session2 = [NSURLSession sharedSession];
    [[session2 dataTaskWithURL:[NSURL URLWithString:URI] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSError* eerror;
          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&eerror];
          
          for(id key in json)
          {
             NSLog(@"key=%@ value=%@", key, [json objectForKey:key]);
          }
          
  //        NSDictionary *test = [json valueForKey:@"main"];
          
          
          //TODO
          dispatch_async(dispatch_get_main_queue(), ^
                         {
                             self.locatie.text =[[json valueForKey:@"city"] valueForKey:@"name"];
                             
                             NSArray * tempMin = [[[json valueForKey:@"list"]valueForKey:@"temp"]valueForKey:@"min"];
                             NSArray * tempMax = [[[json valueForKey:@"list"]valueForKey:@"temp"]valueForKey:@"max"];
                             NSArray * hum = [[json valueForKey:@"list"]valueForKey:@"humidity"];
                             
                             //dag1

                             NSString * tempmind1 = [NSString stringWithFormat:@"%@",[tempMin objectAtIndex:0]];
                             double tempmindd1d = [tabbarViewController kelvinToCelsius:([tempmind1 doubleValue])];
                             self.tempMinD1.text = [NSString stringWithFormat:@"%.00f", tempmindd1d];
                             
                             NSString * tempmaxd1 = [NSString stringWithFormat:@"%@",[tempMax objectAtIndex:0]];
                             double tempmaxd1d = [tabbarViewController kelvinToCelsius:([tempmaxd1 doubleValue])];
                             self.tempMaxD1.text = [NSString stringWithFormat:@"%.00f", tempmaxd1d];
                             
                             //dag2

                             NSString * tempmind2 = [NSString stringWithFormat:@"%@",[tempMin objectAtIndex:1]];
                             double tempmind2d = [tabbarViewController kelvinToCelsius:([tempmind2 doubleValue])];
                             self.tempMinD2.text = [NSString stringWithFormat:@"%.00f", tempmind2d];
                             
                             NSString * tempmaxd2 = [NSString stringWithFormat:@"%@",[tempMax objectAtIndex:1]];
                             double tempmaxd2d = [tabbarViewController kelvinToCelsius:([tempmaxd2 doubleValue])];
                             self.tempMaxD2.text = [NSString stringWithFormat:@"%.00f", tempmaxd2d];
                             
                             //dag3

                             NSString * tempmind3 = [NSString stringWithFormat:@"%@",[tempMin objectAtIndex:2]];
                             double tempmind3d = [tabbarViewController kelvinToCelsius:([tempmind3 doubleValue])];
                             self.tempMinD3.text = [NSString stringWithFormat:@"%.00f", tempmind3d];
                             
                             NSString * tempmaxd3 = [NSString stringWithFormat:@"%@",[tempMax objectAtIndex:2]];
                             double tempmaxd3d = [tabbarViewController kelvinToCelsius:([tempmaxd3 doubleValue])];
                             self.tempMaxD3.text = [NSString stringWithFormat:@"%.00f", tempmaxd3d];
                             
                             
                             
                             
                             
                         });
          // NSString* temp = [[self.currentWeatherData valueForKey:@"main"] valueForKey:@"temp_max"];
          
          //  double tempF =[TabBarController KelvinToFarenheit:([temp doubleValue])];
          //  self.lblMaxC.text = [NSString stringWithFormat:@"%.00f", tempC];
          //  self.lblMaxF.text = [NSString stringWithFormat:@"%.00f", tempF];
          
      }] resume];
}


@end
