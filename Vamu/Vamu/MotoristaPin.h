//
//  MotoristaPin.h
//  Vamu
//
//  Created by Guilherme Augusto on 24/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Rota.h"
#import "Ponto.h"
#import "MotoristaAtivo.h"
#import "Veiculo.h"

@interface MotoristaPin : MKPointAnnotation

@property (nonatomic, strong) UIImage *imagem;
@property (nonatomic, strong) NSString *rotaName;
@property (nonatomic, strong) Rota *rota;
@property (nonatomic, strong) Veiculo *veiculo;
@property (nonatomic, strong) MotoristaAtivo *motoristaAtivo;

-(MotoristaPin*) initWithMotorista:(MotoristaAtivo*) motorista;

@end
