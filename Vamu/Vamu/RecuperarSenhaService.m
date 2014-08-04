//
//  RecuperarSenhaService.m
//  Vamu
//
//  Created by Guilherme Augusto on 20/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "RecuperarSenhaService.h"
#import "AppHelper.h"

@implementation RecuperarSenhaService

-(void)recuperarSenha:(NSString *)cpf{
    NSString *strURL = [self confereURLConexao:@"login/recuperar"];
    if (strURL == nil) {
        return;
    }
    NSString *cpfSemMascara = [AppHelper limparCPF:cpf];
    NSString *url = [NSString stringWithFormat:@"%@/%@", strURL, cpfSemMascara];
    
    [self consultarUrl:url timeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSRange strRange = [self.dadosRetorno rangeOfString:@"HTTP Status 404"];
    if (strRange.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recuperarSenhaFalhaAoEnviar)]) {
            [self.delegate recuperarSenhaFalhaAoEnviar];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange rangeErro = [self.dadosRetorno rangeOfString:@"erro"];
    if (rangeErro.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recuperarSenhaFalhaAoEnviar)]) {
            [self.delegate recuperarSenhaFalhaAoEnviar];
        }
        self.dadosRetorno = nil;
        return;
    }
 
    NSRange strCPFInvalido = [self.dadosRetorno rangeOfString:@"msg:006"];
    if (strCPFInvalido.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recuperarSenhaCPFNaoCadastrado)]) {
            [self.delegate recuperarSenhaCPFNaoCadastrado];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strOk = [self.dadosRetorno rangeOfString:@"msg:017"];
    if (strOk.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recuperarSenhaOk)]) {
            [self.delegate recuperarSenhaOk];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strErro = [self.dadosRetorno rangeOfString:@"Erro:112"];
    if (strErro.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recuperarSenhaFalhaAoEnviar)]) {
            [self.delegate recuperarSenhaFalhaAoEnviar];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recuperarSenhaFalhaAoEnviar)]) {
        [self.delegate recuperarSenhaFalhaAoEnviar];
    }
    
}

-(void)onOcorreuTimeout:(NSString *)msg{
    self.dadosRetorno = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(recuperarSenhaFalhaAoEnviar)]) {
        [self.delegate recuperarSenhaFalhaAoEnviar];
    }
}

@end
