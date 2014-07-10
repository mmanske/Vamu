//
//  AceitacaoCarona.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface AceitacaoCarona : Model

@property (nonatomic, retain) NSNumber * codNotificacao;
@property (nonatomic, retain) NSString * codViagem;
@property (nonatomic, retain) Participante *destinatario;
@property (nonatomic, retain) Participante *remetente;

@end
