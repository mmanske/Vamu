//
//  SeguradoraService.m
//  Vamu
//
//  Created by Guilherme Augusto on 18/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "SeguradoraService.h"

@implementation SeguradoraService

-(void)buscarSeguradoras{
    NSString *strURL = [self confereURLConexao:@"seguradora/buscar"];
    if (strURL == nil) {
        return;
    }
    
    [self consultarUrl:strURL timeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSLog(@"%@", self.dadosRetorno);
    
    NSRange strConfirmacao = [self.dadosRetorno rangeOfString:@"erro"];
    if (strConfirmacao.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(erroAoBuscarSeguradoras)]) {
            [self.delegate erroAoBuscarSeguradoras];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    [Seguradora truncateNoSave];
    
    NSDictionary *dic = [self.dadosRetorno objectFromJSONString];
//    NSDictionary *dicSeguradoras = [dic objectForKey:@"seguradoras"];
    
    for (NSDictionary *dicSeguradora in dic) {
        NSString *descricao = [dicSeguradora objectForKey:@"nome"];
        NSNumber *cod       = [dicSeguradora objectForKey:@"cod"];
        
        Seguradora *seguradora = [Seguradora new];
        seguradora.codSeguradora = cod;
        seguradora.descricao = descricao;
    }
    
    [Model saveAll:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(retornouSeguradoras)]) {
        [self.delegate retornouSeguradoras];
    }
    
}

@end
