//
//  RotaService.m
//  Vamu
//
//  Created by Guilherme Augusto on 24/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "RotaService.h"
#import "Rota.h"
#import "AppHelper.h"

@implementation RotaService

-(NSMutableDictionary*) dicionarioRota:(Rota*) rota{
    NSMutableDictionary *dicRota = [NSMutableDictionary new];
    
    [dicRota setObject:[NSString stringWithFormat:@"%@", rota.descricao] forKey:@"descricao"];
    [dicRota setObject:[AppHelper getParticipanteLogado].codParticipante forKey:@"codParticipante"];
    
    NSMutableArray *pontos = [NSMutableArray new];
    for (Ponto *ponto in rota.pontos) {
        NSMutableDictionary *dicPontos = [NSMutableDictionary new];
        
        [dicPontos setObject:[NSString stringWithFormat:@"%f", ponto.latitude] forKey:@"latitude"];
        [dicPontos setObject:[NSString stringWithFormat:@"%f", ponto.longitude] forKey:@"longitude"];
        [dicPontos setObject:[NSString stringWithFormat:@"%d", ponto.ordem] forKey:@"posicao"];
    
        [pontos addObject:dicPontos];
    }
    
    [dicRota setObject:pontos forKey:@"coordenadas"];
    
    if ([[AppHelper getParticipanteLogado].motorista isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [dicRota setObject:@"1" forKey:@"tipoParticipante"];
    } else {
        [dicRota setObject:@"2" forKey:@"tipoParticipante"];
    }
    
    return dicRota;
}

-(void)enviarRota:(Rota *)rota participante:(Participante *)participante{
    NSString *strURL = [self confereURLConexao:@"rota/definir"];
    if (strURL == nil) {
        return;
    }
    
    NSString *rotaJson = [[self dicionarioRota:rota] JSONString];
    
    [self lancarPost:strURL withPostString:rotaJson withTimeOut:60];
}

-(void)salvarDestinoFavorito:(TrajetoFavorito *)destino{
    NSString *strURL = [self confereURLConexao:@"rota/favorita"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", strURL,
                     [AppHelper getParticipanteLogado].codParticipante,
                     [destino.descricao stringByReplacingOccurrencesOfString:@" " withString:@"%20"],
                     [NSString stringWithFormat:@"%f", destino.latitude],
                     [NSString stringWithFormat:@"%f", destino.longitude]];
    
    [self consultarUrl:url timeOut:60];
}

-(void)cancelarDestinoFavorito:(TrajetoFavorito *)destino{
    NSString *strURL = [self confereURLConexao:@"rota/cancelarFavorita"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", strURL,
                     [AppHelper getParticipanteLogado].codParticipante, destino.codigo];
    
    [self consultarUrl:url timeOut:60];
}

-(void)buscarTrajetoFavorito{
    NSString *strURL = [self confereURLConexao:@"rota/salvarFavorito"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", strURL, [AppHelper getParticipanteLogado].codParticipante];
    
    [self consultarUrl:url timeOut:60];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSLog(@"%@", self.dadosRetorno);
    
    NSRange strErroJson = [self.dadosRetorno rangeOfString:@"Erro:001"];
    if (strErroJson.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(rotaFalhaJSon)]) {
            [self.delegate rotaFalhaJSon];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strFalhaSalvarNotificacoes = [self.dadosRetorno rangeOfString:@"Erro:117"];
    if (strFalhaSalvarNotificacoes.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(rotaFalhaAoSalvarNotificacoes)]) {
            [self.delegate rotaFalhaAoSalvarNotificacoes];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strFalhaSalvarViagem = [self.dadosRetorno rangeOfString:@"Erro:114"];
    if (strFalhaSalvarViagem.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(rotaFalhaAoSalvarViagem)]) {
            [self.delegate rotaFalhaAoSalvarViagem];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strSalvouFavorito = [self.dadosRetorno rangeOfString:@"msg:027"];
    if (strSalvouFavorito.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(salvouRotaFavorita)]) {
            [self.delegate salvouRotaFavorita];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strCancelouFavorito = [self.dadosRetorno rangeOfString:@"msg:028"];
    if (strCancelouFavorito.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelouRotaFavorita)]) {
            [self.delegate cancelouRotaFavorita];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(salvouRota:)]) {
        [self.delegate salvouRota:[NSNumber numberWithInt:[self.dadosRetorno intValue]]];
    }
}

@end
