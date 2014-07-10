//
//  CaronaService.h
//  Vamu
//
//  Created by Guilherme Augusto on 15/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "SolicitacaoCarona.h"

@interface CaronaService : BaseService

-(void) mensagensCancelamento;
-(void) recusarSolicitacao:(SolicitacaoCarona*) solicitacao;
-(void) aceitarSolicitacao:(SolicitacaoCarona*) solicitacao;
-(void) desembarqueCarona:(Participante*) participanteCarona;
-(void) desembarqueMotorista:(Participante*) participanteCarona;

-(void) solicitarCarona:(NSString*) codMotorista destino:(NSString*) destino;

@end

@interface NSObject (CaronaServiceDelegate)

-(void) desembarqueConcluido;
-(void) mensagensCancelamento:(NSArray*) mensagens;
-(void) solicitacaoEnviada;
-(void) solicitacaoAceita;
-(void) falhaAoEnviarSolicitacao;

@end
