//
//  ResumoViagemService.m
//  Vamu
//
//  Created by Guilherme Augusto on 23/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ResumoViagemService.h"
#import "AppHelper.h"

//historico/viagem/{codPessoa}/{codViagem}/{tipoParticipante}

@implementation ResumoViagemService

-(void)resumoViagemCarona{
    NSString *strURL = [self confereURLConexao:@"historico/viagem"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%d/%@/2", strURL, [[AppHelper getParticipanteLogado].codParticipante intValue], [AppHelper getParticipanteLogado].codViagemAtual];
    
    [self consultarUrl:url timeOut:30];
}

-(void)resumoViagemMotorista{
    NSString *strURL = [self confereURLConexao:@"historico/viagem"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%d/%@/1", strURL, [[AppHelper getParticipanteLogado].codParticipante intValue], [AppHelper getParticipanteLogado].codViagemAtual];
    
    [self consultarUrl:url timeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSLog(@"%@", self.dadosRetorno);
    
    NSDictionary *dic = [self.dadosRetorno objectFromJSONString];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRetornouResumo:)]) {
        [self.delegate onRetornouResumo:dic];
    }
}

@end
