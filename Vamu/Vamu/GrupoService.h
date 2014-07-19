//
//  GrupoService.h
//  Vamu
//
//  Created by Guilherme Augusto on 17/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "Grupo.h"
#import "Participante.h"

@interface GrupoService : BaseService

-(void) consultarGruposParticipante;
-(void) enviarConvite:(NSString*) codGrupo email:(NSString*) email;
-(void) consultarGrupoPorPessoa;
-(void) cadastrarGrupo:(Grupo*) grupo;
-(void) consultarGrupoPorNome:(NSString*) nome;
-(void) gruposParticipanteLogado;
-(void) solicitarAdesao:(Grupo*) grupo participanteSolicitante:(Participante*) participante;
-(void) aceitarParticipacao:(NSString*) codGrupo codParticipante:(NSString*) codParticipante;
-(void) cancelarParticipacao:(Grupo*) grupo status:(NSString*) status;

@end

@interface NSObject (GrupoServiceDelegate)

-(void) grupoCadastradoComSucesso;
-(void) grupoEnviaMensagemErro:(NSString*) mensagem;
-(void) grupoNaoValidouNome:(NSString*) mensagem;
-(void) grupoConsultaNomeRetorno:(NSMutableArray*) grupos;
-(void) grupoSolicitacaoEnviada;
-(void) grupoParticipacaoConfirmada;
-(void) grupoCancelamentoEfetuado;
-(void) grupoUsuarioAtualizado;

@end

//Erro:118 - Falha ao salvar grupo
//msg:003 - Grupo cadastrado com sucesso