//
//  ParticipanteResumoVO.h
//  Vamu
//
//  Created by Guilherme Augusto on 28/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@interface ParticipanteResumoVO : Model

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * cpf;
@property (nonatomic, retain) NSString * horaInicio;
@property (nonatomic, retain) NSString * horaFim;
@property (nonatomic, retain) NSString * kmViagem;

@end
