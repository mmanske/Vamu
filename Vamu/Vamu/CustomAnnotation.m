//
//  CustomAnnotation.m
//  Inveni
//
//  Created by Guilherme Augusto on 11/03/14.
//  Copyright (c) 2014 Primus Tech. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

-(id)initWithLocation:(CLLocationCoordinate2D)location expectedTravelTime:(NSTimeInterval)expectedTravelTime{
    self = [super init];
    if (self) {
        _title = [self stringFromTimeInterval:expectedTravelTime];
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"CustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    return annotationView;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
}

@end
