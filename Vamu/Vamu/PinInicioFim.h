//
//  PinInicioFim.h
//  Vamu
//
//  Created by Guilherme Augusto on 11/08/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PinInicioFim : MKPointAnnotation

@property (nonatomic) BOOL ini;
@property (nonatomic, strong) UIImage *imagem;
-(PinInicioFim*) initInLocation:(CLLocation*) location inicio:(BOOL) inicio;

@end
