//
//  huidigweerViewController.h
//  weatherApp
//
//  Created by Sinove on 28/05/14.
//  Copyright (c) 2014 Sinove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
@interface huidigweerViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *location;
    float latitude, longitude;
}
@end
