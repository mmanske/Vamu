//
//  TrajetoFavorito.h
//  Vamu
//
//  Created by Guilherme Augusto on 17/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface TrajetoFavorito : Model

@property (nonatomic, retain) NSString * descricao;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) Participante *participante;
@property (nonatomic, strong) NSNumber *codigo;

@end
