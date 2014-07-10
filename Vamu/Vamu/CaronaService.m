//
//  CaronaService.m
//  Vamu
//
//  Created by Guilherme Augusto on 15/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CaronaService.h"
#import "AppHelper.h"

@implementation CaronaService

-(void)confirmarEmbarque:(Participante *)participante{
    NSString *strURL = [self confereURLConexao:@"carona/embarque"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@", strURL, participante.codParticipante, participante.latitudeAtual, participante.longitudeAtual, [AppHelper getParticipanteLogado].codParticipante, [AppHelper getParticipanteLogado].codViagemAtual];
    
    [self consultarUrl:url timeOut:30];
}

-(void)desembarqueCarona:(Participante *)participanteCarona{
    NSString *strURL = [self confereURLConexao:@"carona/desembarque"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@", strURL, participanteCarona.codParticipante, participanteCarona.latitudeAtual, participanteCarona.longitudeAtual];
    
    [self consultarUrl:url timeOut:30];
}

-(void)desembarqueMotorista:(Participante *)participanteCarona{
    NSString *strURL = [self confereURLConexao:@"motorista/mensagensCancelamento"];
    if (strURL == nil) {
        return;
    }
    
    [self consultarUrl:strURL timeOut:30];
}

-(void)mensagensCancelamento{
    //servidor/VamuServer/motorista/mensagensCancelamento
    
    NSString *strURL = [self confereURLConexao:@"motorista/mensagensCancelamento"];
    if (strURL == nil) {
        return;
    }
    
    [self consultarUrl:strURL timeOut:30];
}

-(void)recusarSolicitacao:(SolicitacaoCarona *)solicitacao{
    NSString *strURL = [self confereURLConexao:@"motorista/respondeSolicitacao"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/5", strURL, solicitacao.remetente.codParticipante, [AppHelper getParticipanteLogado].codParticipante, [solicitacao.mensagem stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    [self consultarUrl:url timeOut:30];
}

-(void)aceitarSolicitacao:(SolicitacaoCarona *)solicitacao{
    //{codPessoaCarona}/{codPessoaMotorista}/{mensagem}/{tipoNotificacao}
    NSString *strURL = [self confereURLConexao:@"motorista/respondeSolicitacao"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/6", strURL, solicitacao.remetente.codParticipante, [AppHelper getParticipanteLogado].codParticipante, [AppHelper getParticipanteLogado].codViagemAtual];
    
    [self consultarUrl:url timeOut:30];
}

-(void)solicitarCarona:(NSString *)codMotorista destino:(NSString *)destino{
    NSString *strURL = [self confereURLConexao:@"carona/solicitar"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@", strURL, [AppHelper getParticipanteLogado].codParticipante, codMotorista, [destino stringByReplacingOccurrencesOfString:@" " withString:@"%20"], [AppHelper getParticipanteLogado].latitudeAtual, [AppHelper getParticipanteLogado].longitudeAtual];
    
    NSLog(@"%@", url);
    
    [self consultarUrl:url timeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSLog(@"%@", self.dadosRetorno);
    
    NSRange strConfirmacao = [self.dadosRetorno rangeOfString:@"msg:021"];
    if (strConfirmacao.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(solicitacaoEnviada)]) {
            [self.delegate solicitacaoEnviada];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strDesembarqueConcluido = [self.dadosRetorno rangeOfString:@"msg:026"];
    if (strDesembarqueConcluido.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(desembarqueConcluido)]) {
            [self.delegate desembarqueConcluido];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strConfirmarEmbarque = [self.dadosRetorno rangeOfString:@"msg:024"];
    if (strConfirmarEmbarque.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(embarqueConcluido)]) {
            [self.delegate embarqueConcluido];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strSolicitacaoAceita = [self.dadosRetorno rangeOfString:@"msg:032"];
    if (strSolicitacaoAceita.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(solicitacaoAceita)]) {
            [self.delegate solicitacaoAceita];
        }
        self.dadosRetorno = nil;
        return;
    }
    NSRange strCaronaAindaNaoEmbarcou = [self.dadosRetorno rangeOfString:@"msg:033"];
    if (strCaronaAindaNaoEmbarcou.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(caronaAindaNaoEmbarcou)]) {
            [self.delegate caronaAindaNaoEmbarcou];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strFalha = [self.dadosRetorno rangeOfString:@"msg:117"];
    if (strFalha.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(falhaAoEnviarSolicitacao)]) {
            [self.delegate falhaAoEnviarSolicitacao];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSArray *arrMensagens = [[NSArray alloc] init];
    arrMensagens = [self.dadosRetorno componentsSeparatedByString:@","];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mensagensCancelamento:)]) {
        [self.delegate mensagensCancelamento:arrMensagens];
    }
    
}

@end
