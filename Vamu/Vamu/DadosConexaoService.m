
//  DadosConexaoService.m
//  ControleVisitas
//
//  Created by Marcio Manske on 22/07/11.
//  Copyright 2011 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import "DadosConexaoService.h"
#import "Configuracao.h"
#import "AppHelper.h"

@interface DadosConexaoService ()

+(NSString*)getBaseURL;
+(NSString*)getURLConexao:(NSString*)contexto;
+(NSString*)getURLConexaoImages;

@end

@implementation DadosConexaoService

+(NSString*)getBaseURL {
    //    return @"http://www.vamu.eco.br/VamuServer";
    //    return "http://172.27.170.182:8080/VamuServer";
    
    // return @"http://107.170.189.97:8080/VamuServer"; teste123
    return @"http://192.168.0.4:8080/VamuServer";
    
}

+(NSString*)getURLConexao:(NSString*)contexto{
    return [NSString stringWithFormat:@"%@/rest/%@", [DadosConexaoService getBaseURL], contexto];
}

+(NSString*)getURLConexaoImages {
    return [NSString stringWithFormat:@"%@/fileServlet", [DadosConexaoService getBaseURL]];
}

+(NSString*)getURLConexaoForServico:(NSString*)contexto{
    return [DadosConexaoService getURLConexao:contexto];
}
+(NSString*)getURLConexaoForImages {
    return [DadosConexaoService getURLConexaoImages];
}

@end