//
//  tabbarViewController.m
//  weatherApp
//
//  Created by Sinove on 28/05/14.
//  Copyright (c) 2014 Sinove. All rights reserved.
//

#import "tabbarViewController.h"

@interface tabbarViewController ()

@end

@implementation tabbarViewController

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

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(double)kelvinToCelsius:(double)kelvin
{
    kelvin -= 273.15;
    
    return kelvin;
}
+(double)kelvinToFar:(double)kelvin //mogelijke uitbreiding voor naar andere eenheid te converteren
{
    kelvin -= kelvin;
    kelvin = (kelvin * 9/5) - 459.67;
    return kelvin;
}

@end
