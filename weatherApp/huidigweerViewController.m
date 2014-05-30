//
//  huidigweerViewController.m
//  weatherApp
//
//  Created by Sinove on 28/05/14.
//  Copyright (c) 2014 Sinove. All rights reserved.
// bij het gebruik maken van locatie heb ik de volgende sites gebruikt : http://stackoverflow.com/questions/19603830/location-manager-giving-null-coordinates en http://stackoverflow.com/questions/4006387/accessing-iphones-current-location
//

#import "huidigweerViewController.h"
#import "tabbarViewController.h"
#import "CoreLocation/CoreLocation.h"

@interface huidigweerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *locatie;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UILabel *minTemp;
@property (weak, nonatomic) IBOutlet UILabel *maxTemp;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *pressure;

@end

@implementation huidigweerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    static int counter =299;
    counter++;
    location = newLocation; // locations is guaranteed to have at least one object
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    
    
    if (counter == 300 ) {
        
        [self getCurrentWeather];
        NSLog(@"%.8f",latitude);
        NSLog(@"%.8f",longitude);
        counter = 0;
    }
    
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
- (void) getCurrentWeather
{
    NSString * URI = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%.8f&lon=%.8f", latitude,longitude];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:URI] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          NSError* eerror;
          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&eerror];
          
          //for(id key in json)
          //{
          //   NSLog(@"key=%@ value=%@", key, [json objectForKey:key]);
          //}
          
         

          
          //TODO
          dispatch_async(dispatch_get_main_queue(), ^
                         {
                             self.locatie.text =[json valueForKey:@"name"];
                             
                             //huidige temp
                             NSString *temp_t =[[json valueForKey:@"main"] valueForKey:@"temp"];
                             double temp =[tabbarViewController kelvinToCelsius:([temp_t doubleValue])];
                             self.currentTemp.text=[NSString stringWithFormat:@"%.00f", temp];
                             
                             //maximale temperatuur
                             NSString *temp_m = [[json valueForKey:@"main"] valueForKey:@"temp_max"];
                             double temp2 =[tabbarViewController kelvinToCelsius:([temp_m doubleValue])];
                             self.maxTemp.text=[NSString stringWithFormat:@"%.00f", temp2];
                             
                             //minimale temperatuur
                             NSString *temp_mi = [[json valueForKey:@"main"] valueForKey:@"temp_min"];
                             double temp3 =[tabbarViewController kelvinToCelsius:([temp_mi doubleValue])];
                             self.minTemp.text=[NSString stringWithFormat:@"%.00f", temp3];
                             
                             //vochtigheid
                             NSString*temp_hum = [[json valueForKey:@"main"] valueForKey:@"humidity"];
                             long temp4 = [temp_hum longLongValue];
                             self.humidity.text = [NSString stringWithFormat:@"%d", temp4];
                           
                             
      
                        
                         });
         // NSString* temp = [[self.currentWeatherData valueForKey:@"main"] valueForKey:@"temp_max"];
          
        //  double tempF =[TabBarController KelvinToFarenheit:([temp doubleValue])];
        //  self.lblMaxC.text = [NSString stringWithFormat:@"%.00f", tempC];
        //  self.lblMaxF.text = [NSString stringWithFormat:@"%.00f", tempF];
          
      }] resume];
}

@end
