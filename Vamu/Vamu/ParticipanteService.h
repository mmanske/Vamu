//
//  ParticipanteService.h
//  Vamu
//
//  Created by Guilherme Augusto on 07/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//



#import "BaseService.h"
#import "Participante.h"
#import "Veiculo.h"

@interface ParticipanteService : BaseService

-(void) cadastrarParticipante:(Participante*) participante;
-(void) alterarParticipante:(Participante*) participante;

@end

@interface NSObject (ParticipanteServiceDelegate)

#pragma mark - Cadastro de participante
-(void) participanteCadastradoComSucesso:(NSString*) codParticipante;
-(void) participanteEnviaMensagemErro:(NSString*) mensagem;
-(void) participanteNaoValidouEmail:(NSString*) mensagem;
-(void) participanteNaoValidouCPF:(NSString*) mensagem;
-(void) participanteNaoValidouApelido:(NSString*) mensagem;

#pragma mark - Alteração de participante
-(void) participanteAlteradoComSucesso:(NSString*) codParticipante;
-(void) participanteErroNaAlteracao:(NSString*) msgDeErro;

@end