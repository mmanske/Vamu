//
//  PinInicioFim.m
//  Vamu
//
//  Created by Guilherme Augusto on 11/08/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "PinInicioFim.h"

@implementation PinInicioFim

@synthesize imagem, ini;

-(PinInicioFim *)initInLocation:(CLLocation *)location inicio:(BOOL)inicio{
    
    self.coordinate = location.coordinate;
    
    self.ini = inicio;
    
    if (inicio) {
        self.title = @"Início";
        imagem     = [UIImage imageNamed:@"ponto-a.png"];
    } else {
        self.title = @"Fim";
        imagem     = [UIImage imageNamed:@"ponto-b.png"];
    }
    
    return self;
}

@end
