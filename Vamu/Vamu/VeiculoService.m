//
//  VeiculoService.m
//  Vamu
//
//  Created by Guilherme Augusto on 07/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "VeiculoService.h"
#import "Seguradora.h"

@implementation VeiculoService

-(void)cadastrarVeiculo:(Veiculo *)veiculo{
    NSString *strURL = [self confereURLConexao:@"veiculo/novo"];
    if (strURL == nil) {
        return;
    }

    NSMutableDictionary *dicVeiculo = [NSMutableDictionary new];
    [dicVeiculo setObject:veiculo.ano forKey:@"ano"];
    [dicVeiculo setObject:veiculo.cor forKey:@"cor"];
//    [dicVeiculo setObject:[veiculo.foto base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] forKey:@"foto"];
    [dicVeiculo setObject:veiculo.marca forKey:@"marca"];
    [dicVeiculo setObject:veiculo.modelo forKey:@"modelo"];
    [dicVeiculo setObject:veiculo.placa forKey:@"placa"];
    [dicVeiculo setObject:veiculo.renavan forKey:@"renavam"];
    [dicVeiculo setObject:veiculo.seguradora forKey:@"seguradora"];
    [dicVeiculo setObject:veiculo.participante.codParticipante forKey:@"codPessoa"];
    [dicVeiculo setObject:veiculo.seg.codSeguradora forKey:@"codSeguradora"];

    NSString *veiculoJson = [dicVeiculo JSONString];
    
    [self lancarPost:strURL withPostString:veiculoJson withTimeOut:60];
}

-(void)editarVeiculo:(Veiculo *)veiculo{
    NSString *strURL = [self confereURLConexao:@"veiculo/editar"];
    if (strURL == nil) {
        return;
    }
    
    NSMutableDictionary *dicVeiculo = [NSMutableDictionary new];
    [dicVeiculo setObject:veiculo.ano forKey:@"ano"];
    [dicVeiculo setObject:veiculo.cor forKey:@"cor"];
//    [dicVeiculo setObject:[veiculo.foto base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] forKey:@"foto"];
    [dicVeiculo setObject:veiculo.marca forKey:@"marca"];
    [dicVeiculo setObject:veiculo.modelo forKey:@"modelo"];
    [dicVeiculo setObject:veiculo.placa forKey:@"placa"];
    [dicVeiculo setObject:veiculo.renavan forKey:@"renavam"];
    [dicVeiculo setObject:veiculo.seguradora forKey:@"seguradora"];
    [dicVeiculo setObject:veiculo.participante.codParticipante forKey:@"codPessoa"];
    [dicVeiculo setObject:veiculo.seg.codSeguradora forKey:@"codSeguradora"];
    
    NSString *veiculoJson = [dicVeiculo JSONString];
    
    [self lancarPost:strURL withPostString:veiculoJson withTimeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSLog(@"%@", self.dadosRetorno);
    
    NSRange strRange = [self.dadosRetorno rangeOfString:@"HTTP Status 404"];
    if (strRange.length > 0) {
        [self enviaMensagemErro:@"Erro na carga de dados"];
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange rangeErro = [self.dadosRetorno rangeOfString:@"Erro"];
    if (rangeErro.length > 0) {
        [self enviaMensagemErro:@"Falha ao processar requisição. Tente novamente"];
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange rangeErro001 = [self.dadosRetorno rangeOfString:@"Erro:001"];
    if (rangeErro001.length > 0) {
        [self enviaMensagemErro:@"Erro ao salvar veículo"];
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strRangeMsg1 = [self.dadosRetorno rangeOfString:@"falha:503"];
    if (strRangeMsg1.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(veiculoNaoValidouPlaca:)]) {
            [self.delegate veiculoNaoValidouPlaca:@"Placa já cadastrada"];
        }
        return;
    }
    
    NSRange strRangeMsg2 = [self.dadosRetorno rangeOfString:@"falha:504"];
    if (strRangeMsg2.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(veiculoNaoValidouRenavan:)]) {
            [self.delegate veiculoNaoValidouRenavan:@"Renavan já cadastrado"];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(veiculoCadastradoComSucesso)]) {
        [self.delegate veiculoCadastradoComSucesso];
    }
    
    self.dadosRetorno = nil;
}

-(void)enviaMensagemErro:(NSString *)msgErro{
    if (self.delegate && [self.delegate respondsToSelector:@selector(veiculoEnviaMensagemErro:)]) {
        [self.delegate veiculoEnviaMensagemErro:msgErro];
    }
}

-(void)onOcorreuTimeout:(NSString *)msg{
    self.dadosRetorno = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(veiculoEnviaMensagemErro:)]) {
        [self.delegate veiculoEnviaMensagemErro:@"Tempo esgotado"];
    }
}

@end
