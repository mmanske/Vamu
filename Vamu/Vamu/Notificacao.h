//
//  Notificacao.h
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface Notificacao : Model

@property (nonatomic, retain) NSNumber * codGrupo;
@property (nonatomic, retain) NSNumber * codigo;
@property (nonatomic, retain) NSString * dataCadastro;
@property (nonatomic, retain) NSString * mensagem;
@property (nonatomic, retain) NSString * nomeGrupo;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) NSNumber * viagens;
@property (nonatomic, retain) NSString * nomeDestino;
@property (nonatomic, retain) Participante *destinatario;
@property (nonatomic, retain) Participante *solicitante;

@end
