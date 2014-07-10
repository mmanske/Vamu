//
//  BaixarImagem.h
//  Vamu
//
//  Created by Márcio S. Manske on 03/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"

@interface BaixarImagemService : BaseService

-(void) baixarImagemDePessoa:(NSString*) cpf;
-(void) baixarImagemDeCarro:(NSString*) cpf placa:(NSString*) placa;

@end


@interface NSObject (BaixarImagemServiceDelegate)
-(void) finalizaBaixarImagem;
@end