//
//  ConsultaGrupoService.m
//  Vamu
//
//  Created by Guilherme Augusto on 31/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ConsultaGrupoService.h"
#import "Grupo.h"

@implementation ConsultaGrupoService

-(void)consultarGruposParticipante:(NSString *)codParticipante{
    NSString *strURL = [self confereURLConexao:@"grupo/consultaParticipantes"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", strURL, codParticipante];
    
    [self consultarUrl:url timeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSRange strErro = [self.dadosRetorno rangeOfString:@"Erro:118"];
    if (strErro.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoConsultaEnviaMensagemErro:)]) {
            [self.delegate grupoConsultaEnviaMensagemErro:@"Erro ao cadastrar grupo"];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSMutableArray *gruposRetorno = [NSMutableArray new];
    
    NSDictionary *dic = [self.dadosRetorno objectFromJSONString];
    for (NSDictionary *dicGrupo in dic) {
        Grupo *grupo = [Grupo new];
        grupo.codGrupo = [NSString stringWithFormat:@"%@", [dicGrupo objectForKey:@"codGrupo"]];
        grupo.descricao = [NSString stringWithFormat:@"%@", [dicGrupo objectForKey:@"descricao"]];
        grupo.nome = [NSString stringWithFormat:@"%@", [dicGrupo objectForKey:@"nome"]];
        
        [gruposRetorno addObject:grupo];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(grupoConsultaRetorno:)]) {
        [self.delegate grupoConsultaRetorno:gruposRetorno];
    }
}

@end
