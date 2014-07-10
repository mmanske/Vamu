//
//  RecuperarSenhaService.h
//  Vamu
//
//  Created by Guilherme Augusto on 20/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"

@interface RecuperarSenhaService : BaseService

-(void) recuperarSenha:(NSString*) cpf;

@end



@interface NSObject (RecuperarSenhaServiceDelegate)

-(void) recuperarSenhaOk;
-(void) recuperarSenhaCPFNaoCadastrado;
-(void) recuperarSenhaFalhaAoEnviar;

@end
