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
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/5", strURL, solicitacao.remetente.codParticipante, [AppHelper getParticipanteLogado].codParticipante, solicitacao.mensagem];
    
    [self consultarUrl:url timeOut:30];
}

-(void)aceitarSolicitacao:(SolicitacaoCarona *)solicitacao{
    //{codPessoaCarona}/{codPessoaMotorista}/{mensagem}/{tipoNotificacao}
    NSString *strURL = [self confereURLConexao:@"motorista/respondeSolicitacao"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/6", strURL, solicitacao.remetente.codParticipante, [AppHelper getParticipanteLogado].codParticipante, solicitacao.mensagem];
    
    [self consultarUrl:url timeOut:30];
}

-(void)solicitarCarona:(NSString *)codMotorista destino:(NSString *)destino{
    NSString *strURL = [self confereURLConexao:@"carona/solicitar"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@", strURL, [AppHelper getParticipanteLogado].codParticipante, codMotorista,@"%20"];
    
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
    
    NSRange strSolicitacaoAceita = [self.dadosRetorno rangeOfString:@"msg:032"];
    if (strSolicitacaoAceita.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(solicitacaoAceita)]) {
            [self.delegate solicitacaoAceita];
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
