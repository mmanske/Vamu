//
//  Veiculo.h
//  Vamu
//
//  Created by Guilherme Augusto on 18/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante, Seguradora;

@interface Veiculo : Model

@property (nonatomic, retain) NSString * ano;
@property (nonatomic, retain) NSString * cor;
@property (nonatomic, retain) NSNumber * idBanco;
@property (nonatomic, retain) NSString * marca;
@property (nonatomic, retain) NSString * modelo;
@property (nonatomic, retain) NSString * placa;
@property (nonatomic, retain) NSString * renavan;
@property (nonatomic, retain) NSString * seguradora;
@property (nonatomic, retain) Participante *participante;
@property (nonatomic, retain) NSNumber *codSeguradora;

@end
