//
//  VeiculoService.h
//  Vamu
//
//  Created by Guilherme Augusto on 07/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "Veiculo.h"
#import "Participante.h"

@interface VeiculoService : BaseService

-(void) cadastrarVeiculo:(Veiculo*) veiculo;
-(void) editarVeiculo:(Veiculo*) veiculo;

@end

@interface NSObject (VeiculoServiceDelegate)

-(void) veiculoCadastradoComSucesso;
-(void) veiculoEnviaMensagemErro:(NSString*) mensagem;
-(void) veiculoNaoValidouPlaca:(NSString*) mensagem;
-(void) veiculoNaoValidouRenavan:(NSString*) mensagem;

@end