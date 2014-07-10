//
//  EnviarImagemService.h
//  Vamu
//
//  Created by Márcio S. Manske on 03/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"

@interface EnviarImagemService : BaseService

-(void) enviarImagemDePessoa:(NSString*) cpf imagem:(NSData*) imagem;
-(void) enviarImagemDeCarro:(NSString*) cpf placa:(NSString*) placa imagem:(NSData*) imagem;


@end


@interface NSObject (EnviarImagemServiceDelegate)
-(void) finalizaEnviarImagem;
-(void) erroAoEnviarImagem;
@end