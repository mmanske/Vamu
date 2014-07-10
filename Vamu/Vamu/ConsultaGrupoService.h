//
//  ConsultaGrupoService.h
//  Vamu
//
//  Created by Guilherme Augusto on 31/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"

@interface ConsultaGrupoService : BaseService

-(void) consultarGruposParticipante:(NSString*) codParticipante;

@end

@interface NSObject (ConsultaGrupoServiceDelegate)

-(void) grupoConsultaEnviaMensagemErro:(NSString*) mensagem;
-(void) grupoConsultaRetorno:(NSMutableArray*) grupos;

@end