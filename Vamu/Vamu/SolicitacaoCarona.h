//
//  SolicitacaoCarona.h
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface SolicitacaoCarona : Model

@property (nonatomic, retain) NSString * apelidoRemetente;
@property (nonatomic, retain) NSNumber * codgrupo;
@property (nonatomic, retain) NSNumber * codNotificacao;
@property (nonatomic, retain) NSNumber * codRemetente;
@property (nonatomic, retain) NSString * mensagem;
@property (nonatomic, retain) NSString * nomeRemetente;
@property (nonatomic, retain) NSNumber * numViagens;
@property (nonatomic, retain) NSNumber * recebida;
@property (nonatomic, retain) NSNumber * tipo;
@property (nonatomic, retain) NSString * nomeDestino;
@property (nonatomic, retain) Participante *destinatario;
@property (nonatomic, retain) Participante *remetente;

@end
