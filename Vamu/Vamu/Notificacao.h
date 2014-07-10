//
//  Notificacao.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface Notificacao : Model

@property (nonatomic, retain) NSNumber * codGrupo;
@property (nonatomic, retain) NSNumber * codigo;
@property (nonatomic, retain) NSString * dataCadastro;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * mensagem;
@property (nonatomic, retain) NSString * nomeDestino;
@property (nonatomic, retain) NSString * nomeGrupo;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) NSNumber * viagens;
@property (nonatomic, retain) NSString * modeloVeiculo;
@property (nonatomic, retain) NSString * placaVeiculo;
@property (nonatomic, retain) NSString * corVeiculo;
@property (nonatomic, retain) NSString * anoVeiculo;
@property (nonatomic, retain) NSNumber * numViagensMotorista;
@property (nonatomic, retain) Participante *destinatario;
@property (nonatomic, retain) Participante *solicitante;

@end
