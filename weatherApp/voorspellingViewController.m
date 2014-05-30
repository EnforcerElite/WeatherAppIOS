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
@property (weak, nonatomic) IBOutlet UILabel *tempD1;
@property (weak, nonatomic) IBOutlet UILabel *tempMinD1;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxD1;
@property (weak, nonatomic) IBOutlet UILabel *humidityD1;
@property (weak, nonatomic) IBOutlet UILabel *tempD2;
@property (weak, nonatomic) IBOutlet UILabel *tempMinD2;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxD2;
@property (weak, nonatomic) IBOutlet UILabel *humidityD2;
@property (weak, nonatomic) IBOutlet UILabel *tempD3;
@property (weak, nonatomic) IBOutlet UILabel *tempMinD3;
@property (weak, nonatomic) IBOutlet UILabel *tempMaxD3;
@property (weak, nonatomic) IBOutlet UILabel *humidityD3;

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
                             
                             NSArray *weer = [json valueForKey:@"list"];
                             
                             NSArray * temp = [[[json valueForKey:@"list"]valueForKey:@"temp"]valueForKey:@"day"];
                             NSArray * tempMin = [[[json valueForKey:@"list"]valueForKey:@"temp"]valueForKey:@"min"];
                             NSArray * tempMax = [[[json valueForKey:@"list"]valueForKey:@"temp"]valueForKey:@"max"];
                             
                             NSArray * hum = [[json valueForKey:@"list"]valueForKey:@"humidity"];
                             
                             NSString * tempd1 = [NSString stringWithFormat:@"%@",[temp objectAtIndex:0]];
                             double tempd1d = [tabbarViewController kelvinToCelsius:([tempd1 doubleValue])];
                             self.tempD1.text = [NSString stringWithFormat:@"%.00f", tempd1d];
                             
                             //huidige temp
                             NSArray *temp_t =[[json valueForKey:@"main"] valueForKey:@"temp"];
                             //double temp =[tabbarViewController kelvinToCelsius:([temp_t doubleValue])];
                             //self.currentTemp.text=[NSString stringWithFormat:@"%.00f", temp];
                             
                             //maximale temperatuur
                            // NSString *temp_m = [[json valueForKey:@"main"] valueForKey:@"temp_max"];
                            // double temp2 =[tabbarViewController kelvinToCelsius:([temp_m doubleValue])];
                             //self.maxTemp.text=[NSString stringWithFormat:@"%.00f", temp2];
                             
                             //minimale temperatuur
                             //NSString *temp_mi = [[json valueForKey:@"main"] valueForKey:@"temp_min"];
                             //double temp3 =[tabbarViewController kelvinToCelsius:([temp_mi doubleValue])];
                            // self.minTemp.text=[NSString stringWithFormat:@"%.00f", temp3];
                             
                             //vochtigheid
                            // NSString*temp_hum = [[json valueForKey:@"main"] valueForKey:@"humidity"];
                             //long temp4 = [temp_hum longLongValue];
                             //self.humidity.text = [NSString stringWithFormat:@"%d", temp4];
                             
                             
                             
                             
                         });
          // NSString* temp = [[self.currentWeatherData valueForKey:@"main"] valueForKey:@"temp_max"];
          
          //  double tempF =[TabBarController KelvinToFarenheit:([temp doubleValue])];
          //  self.lblMaxC.text = [NSString stringWithFormat:@"%.00f", tempC];
          //  self.lblMaxF.text = [NSString stringWithFormat:@"%.00f", tempF];
          
      }] resume];
}


@end
