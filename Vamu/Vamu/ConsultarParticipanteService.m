//
//  ConsultarParticipanteService.m
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ConsultarParticipanteService.h"

@implementation ConsultarParticipanteService

-(void)consultarParticipante:(NSString *)codParticipante{
    NSString *strURL = [self confereURLConexao:@"usuario/consultar"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", strURL, codParticipante];
    
    [self consultarUrl:url timeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    NSLog(@"%@", self.dadosRetorno);
}

@end
