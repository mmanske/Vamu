//
//  EnviarImagemService.m
//  Vamu
//
//  Created by Márcio S. Manske on 03/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "EnviarImagemService.h"
#import "AppHelper.h"

@implementation EnviarImagemService


-(void) enviar:(NSString*) nomeArquivo imagem:(NSData*) imagem{
    NSString *strURL = [DadosConexaoService getURLConexaoForImages];
    if (strURL == nil) {
        return;
    }
    [self lancarPost:strURL withFileName:nomeArquivo withData:imagem withTimeOut:120];
}

-(void) enviarImagemDePessoa:(NSString*) cpf imagem:(NSData*) imagem{
    NSString *nomeArquivo = [NSString stringWithFormat:@"%@.jpg", [AppHelper limparCPF:cpf]];
    [self enviar:nomeArquivo imagem:imagem];
}

-(void) enviarImagemDeCarro:(NSString*) cpf placa:(NSString*) placa imagem:(NSData*) imagem{
    NSString *nomeArquivo = [NSString stringWithFormat:@"%@-%@.jpg", [AppHelper limparCPF:cpf], placa];
    [self enviar:nomeArquivo imagem:imagem];
}

-(void)trataRecebimento{
    NSLog(@"%@", self.dadosRetorno);
    NSRange okMessage = [self.dadosRetorno rangeOfString:@"OK"];
    
    if (okMessage.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(finalizaEnviarImagem)]) {
            [self.delegate finalizaEnviarImagem];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(erroAoEnviarImagem)]) {
        [self.delegate erroAoEnviarImagem];
    }
    
}

@end
