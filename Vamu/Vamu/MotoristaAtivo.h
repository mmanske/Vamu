//
//  MotoristaAtivo.h
//  Vamu
//
//  Created by Guilherme Augusto on 07/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Rota, Veiculo;

@interface MotoristaAtivo : Model

@property (nonatomic, retain) NSString * descViagem;
@property (nonatomic, retain) NSNumber * codViagem;
@property (nonatomic, retain) NSNumber * codPessoa;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) Veiculo *veiculo;
@property (nonatomic, retain) Rota *rota;

@end
