//
//  CaronaDesembarcou.h
//  Vamu
//
//  Created by Guilherme Augusto on 15/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface CaronaDesembarcou : Model

@property (nonatomic, retain) NSNumber * codNotificacao;
@property (nonatomic, retain) Participante *remetente;
@property (nonatomic, retain) Participante *destinatario;

@end
