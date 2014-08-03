//
//  MotoristaAtivo.h
//  Vamu
//
//  Created by MF INFORMATICA LTDA on 03/08/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Rota, Veiculo;

@interface MotoristaAtivo : Model

@property (nonatomic, retain) NSNumber * codPessoa;
@property (nonatomic, retain) NSNumber * codViagem;
@property (nonatomic, retain) NSString * descViagem;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * cpf;
@property (nonatomic, retain) NSNumber * quantViagens;
@property (nonatomic, retain) NSNumber * distMetros;
@property (nonatomic, retain) NSNumber * distSegundos;
@property (nonatomic, retain) NSString * nomeMotorista;
@property (nonatomic, retain) Rota *rota;
@property (nonatomic, retain) Veiculo *veiculo;

@end
