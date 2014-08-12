//
//  CaronaPin.h
//  Vamu
//
//  Created by Guilherme Augusto on 11/08/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CaronaPin : MKPointAnnotation

@property (nonatomic, strong) UIImage *image;

-(CaronaPin*) initInLocation:(CLLocation*) location;

@end
