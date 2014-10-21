//
//  CaronaPin.m
//  Vamu
//
//  Created by Guilherme Augusto on 11/08/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CaronaPin.h"


@implementation CaronaPin

@synthesize image;

-(CaronaPin *)initInLocation:(CLLocation *)location{
    
    self.coordinate = location.coordinate;
    self.title      = @"Início";
    image           = [UIImage imageNamed:@"pin-mapa-verde_5.png"];

    return self;
    
}

-(CaronaPin*) initWithCarona:(Participante*) carona {
    self.coordinate = CLLocationCoordinate2DMake([carona.latitudeAtual floatValue], [carona.longitudeAtual floatValue]);
    self.title      = carona.apelido;
    image          = [UIImage imageNamed:@"pin-mapa-verde_5.png"];
    return self;
    
}

@end
