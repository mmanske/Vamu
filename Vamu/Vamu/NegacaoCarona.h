//
//  NegacaoCarona.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface NegacaoCarona : Model

@property (nonatomic, retain) NSString * ano;
@property (nonatomic, retain) NSNumber * codNotificacao;
@property (nonatomic, retain) NSString * codViagem;
@property (nonatomic, retain) NSString * cor;
@property (nonatomic, retain) NSString * modeloVeiculo;
@property (nonatomic, retain) NSNumber * numViagensMotorista;
@property (nonatomic, retain) NSString * placa;
@property (nonatomic, retain) NSString * mensagem;
@property (nonatomic, retain) Participante *remetente;
@property (nonatomic, retain) Participante *destinatario;

@end
