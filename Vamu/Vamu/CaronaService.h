//
//  CaronaService.h
//  Vamu
//
//  Created by Guilherme Augusto on 15/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "SolicitacaoCarona.h"
#import "AceitacaoCarona.h"

@interface CaronaService : BaseService

-(void) mensagensCancelamento;
-(void) recusarSolicitacao:(SolicitacaoCarona*) solicitacao;
-(void) aceitarSolicitacao:(SolicitacaoCarona*) solicitacao;
-(void) desembarqueCarona:(Participante*) participanteCarona;
-(void) desembarqueMotorista:(Participante*) participanteCarona;
-(void) solicitarCarona:(NSString*) codMotorista destino:(NSString*) destino;

-(void) confirmarEmbarque:(Participante*) participante;
-(void) caronaConfirmarEmbarque:(AceitacaoCarona*) solicitacao;
-(void) caronaCancelaEmbarque:(AceitacaoCarona*) solicitacao;

@end

@interface NSObject (CaronaServiceDelegate)

-(void) desembarqueConcluido;
-(void) embarqueConcluido;
-(void) mensagensCancelamento:(NSArray*) mensagens;
-(void) solicitacaoEnviada;
-(void) solicitacaoAceita;
-(void) falhaAoEnviarSolicitacao;
-(void) caronaAindaNaoEmbarcou;

@end
