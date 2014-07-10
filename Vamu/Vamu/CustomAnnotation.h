//
//  CustomAnnotation.h
//  Inveni
//
//  Created by Guilherme Augusto on 11/03/14.
//  Copyright (c) 2014 Primus Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

-(id) initWithLocation:(CLLocationCoordinate2D) location expectedTravelTime:(NSTimeInterval) expectedTravelTime;
-(MKAnnotationView*) annotationView;

@end
