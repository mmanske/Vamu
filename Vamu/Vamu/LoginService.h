//
//  LoginService.h
//  Vamu
//
//  Created by Guilherme Augusto on 17/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "Participante.h"

@interface LoginService : BaseService

-(void) fazerLoginComCPF:(NSString*) cpf eSenha:(NSString*) senha;
-(void) derrubarSessao:(NSString*) cpf;

@end

@interface NSObject (LoginServiceDelegate)

-(void) loginOk:(Participante*) participante;
-(void) loginCPFNaoCadastrado;
-(void) loginSenhaInvalida;
-(void) loginMotoristaComViagem;
-(void) loginMotoristaSemViagem;
-(void) loginCaronComViagem;
-(void) loginCaronSemViagem;
-(void) loginComAtivoEmOutroAparelho;
-(void) loginContaNaoAtiva:(Participante*) participante;
-(void) loginErroSenhaTerceiraTentativa;
-(void) loginFalhaAoSalvarAcesso;
-(void) loginErro:(NSString*) erro;

@end
