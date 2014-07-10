//
//  MotoristaPin.m
//  Vamu
//
//  Created by Guilherme Augusto on 24/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "MotoristaPin.h"

@implementation MotoristaPin

@synthesize imagem, rota, rotaName, veiculo, motoristaAtivo;

-(MotoristaPin *)initWithMotorista:(MotoristaAtivo *)motorista{
    
    self.coordinate = CLLocationCoordinate2DMake([motorista.latitude floatValue], [motorista.longitude floatValue]);
    self.title      = motorista.descViagem;
    
    motoristaAtivo  = motorista;
    imagem          = [UIImage imageNamed:@"pin-mapa-azulescuro_5.png"];
    rota            = motorista.rota;
    veiculo         = motorista.veiculo;
    
    return self;
    
}

@end
