//
//  SolicitacaoAdesao.h
//  Vamu
//
//  Created by Guilherme Augusto on 01/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface SolicitacaoAdesao : Model

@property (nonatomic, retain) NSString * nomeGrupo;
@property (nonatomic, retain) NSNumber * codGrupo;
@property (nonatomic, retain) NSNumber * codNotificacao;
@property (nonatomic, retain) NSNumber * recebida;
@property (nonatomic, retain) NSNumber * viagens;
@property (nonatomic, retain) NSString * dataCadastro;
@property (nonatomic, retain) Participante *remetente;
@property (nonatomic, retain) Participante *destinatario;

@end
