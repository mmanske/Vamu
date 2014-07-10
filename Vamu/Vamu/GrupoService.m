//
//  GrupoService.m
//  Vamu
//
//  Created by Guilherme Augusto on 17/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "GrupoService.h"
#import "AppHelper.h"

@implementation GrupoService

-(NSMutableDictionary*) dicionarioGrupo:(Grupo*) grupo{
    NSMutableDictionary *dicGrupo = [NSMutableDictionary new];

    [dicGrupo setObject:grupo.nome forKey:@"nome"];
    [dicGrupo setObject:grupo.descricao forKey:@"descricao"];
    [dicGrupo setObject:grupo.visivel forKey:@"visibilidade"];
    [dicGrupo setObject:grupo.receberSolicitacao forKey:@"solicitacaoAdesao"];
    [dicGrupo setObject:grupo.ativarFiltros forKey:@"ativarFiltros"];
    if ([AppHelper getParticipanteLogado]) {
        [dicGrupo setObject:grupo.moderador.codParticipante forKey:@"codPessoa"];
    } else {
        [dicGrupo setObject:@"1" forKey:@"codPessoa"];
    }
    
    return dicGrupo;
}

-(void)cancelarParticipacao:(Grupo *)grupo status:(NSString*)status{
    NSString *strURL = [self confereURLConexao:@"grupo/atualizarStatusParticipante"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@", strURL, grupo.codGrupo, [AppHelper getParticipanteLogado].codParticipante, status];
    
    [self consultarUrl:url timeOut:30];
}

-(void)aceitarParticipacao:(NSString *)codGrupo codParticipante:(NSString *)codParticipante{
    NSString *strURL = [self confereURLConexao:@"grupo/aceitarInclusao"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", strURL, codGrupo, codParticipante];
    
    [self consultarUrl:url timeOut:30];
}

-(void)consultarGrupoPorNome:(NSString *)nome{
    NSString *strURL = [self confereURLConexao:@"grupo/consultarPorApelido"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", strURL, [AppHelper getParticipanteLogado].codParticipante, nome];
    
    [self consultarUrl:url timeOut:30];
}

-(void)solicitarAdesao:(Grupo *)grupo participanteSolicitante:(Participante *)participante{
    NSString *strURL = [self confereURLConexao:@"grupo/solicitacao"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", strURL, grupo.codGrupo, participante.codParticipante];
    
    [self consultarUrl:url timeOut:30];
}

-(void)cadastrarGrupo:(Grupo *)grupo{
    NSString *strURL = [self confereURLConexao:@"grupo/novo"];
    if (strURL == nil) {
        return;
    }
    
    NSString *grupoJson = [[self dicionarioGrupo:grupo] JSONString];
    
    [self lancarPost:strURL withPostString:grupoJson withTimeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSLog(@"%@", self.dadosRetorno);
    
    NSRange strErro = [self.dadosRetorno rangeOfString:@"Erro:118"];
    if (strErro.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoEnviaMensagemErro:)]) {
            [self.delegate grupoEnviaMensagemErro:@"Erro ao cadastrar grupo"];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strErro117 = [self.dadosRetorno rangeOfString:@"Erro:117"];
    if (strErro117.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoEnviaMensagemErro:)]) {
            [self.delegate grupoEnviaMensagemErro:@"Falha ao enviar solicitação"];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strErro112 = [self.dadosRetorno rangeOfString:@"Erro:112"];
    if (strErro112.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoEnviaMensagemErro:)]) {
            [self.delegate grupoEnviaMensagemErro:@"Falha ao enviar solicitação"];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strOk = [self.dadosRetorno rangeOfString:@"msg:003"];
    if (strOk.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoCadastradoComSucesso)]) {
            [self.delegate grupoCadastradoComSucesso];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strOkSolicitacao = [self.dadosRetorno rangeOfString:@"msg:005"];
    if (strOkSolicitacao.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoSolicitacaoEnviada)]) {
            [self.delegate grupoSolicitacaoEnviada];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strConfirmacao = [self.dadosRetorno rangeOfString:@"msg:019"];
    if (strConfirmacao.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoParticipacaoConfirmada)]) {
            [self.delegate grupoParticipacaoConfirmada];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange str020 = [self.dadosRetorno rangeOfString:@"msg:020"];
    if (str020.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoCancelamentoEfetuado)]) {
            [self.delegate grupoCancelamentoEfetuado];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSMutableArray *gruposRetorno = [NSMutableArray new];
    
    NSDictionary *dic = [self.dadosRetorno objectFromJSONString];
    for (NSDictionary *dicGrupo in dic) {
        Grupo *grupo = [Grupo new];
        grupo.visivel = [NSNumber numberWithInt:[[dicGrupo objectForKey:@"visibilidade"] intValue]];
        grupo.ativarFiltros = [NSNumber numberWithBool:[[dicGrupo objectForKey:@"ativarFiltros"] intValue]];
        grupo.receberSolicitacao = [NSNumber numberWithBool:[[dicGrupo objectForKey:@"solicitacaoAdesao"] intValue]];
        grupo.descricao = [NSString stringWithFormat:@"%@", [dicGrupo objectForKey:@"descricao"]];
        grupo.nome = [NSString stringWithFormat:@"%@", [dicGrupo objectForKey:@"nome"]];
        grupo.codGrupo = [NSString stringWithFormat:@"%@", [dicGrupo objectForKey:@"codGrupo"]];
        
        [gruposRetorno addObject:grupo];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(grupoConsultaNomeRetorno:)]) {
        [self.delegate grupoConsultaNomeRetorno:gruposRetorno];
    }
    
}

-(void)onOcorreuTimeout:(NSString *)msg{
    if (self.delegate && [self.delegate respondsToSelector:@selector(grupoEnviaMensagemErro:)]) {
        [self.delegate grupoEnviaMensagemErro:@"Tempo limite esgotado"];
    }
}

@end
