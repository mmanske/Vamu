//
//  DadosConexaoService.h
//  ControleVisitas
//
//  Created by Marcio Manske on 22/07/11.
//  Copyright 2011 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DadosConexaoService : NSObject {
    
}

+(NSString*)getURLConexaoForServico:(NSString*)contexto;
+(NSString*)getURLConexaoForImages;

@end
