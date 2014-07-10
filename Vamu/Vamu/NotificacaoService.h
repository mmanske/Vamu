//
//  NotificacaoService.h
//  Vamu
//
//  Created by Guilherme Augusto on 01/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "Notificacao.h"
#import "Participante.h"

//public static int tipoNotificacao_motoristaLogado = 1;
//public static int tipoNotificacao_SolicitacaoInclusaoNoGrupo = 2;
//public static int tipoNotificacao_PedidoExclusaoGrupo = 3;

@interface NotificacaoService : BaseService

-(void) notificacaoParaParticipante:(Participante*) participante;
-(void) confirmacaoLeitura:(NSNumber*) codNotificacao;

@end

@interface NSObject (NotificacaoServiceDelegate)

-(void) notificacaoesRecebidas: (NSMutableArray*) notificacoes grupos:(NSMutableArray*) grupos motoristas:(NSMutableArray*) motoristas;
-(void) notificacaoesConfirmouLeitura;

@end
