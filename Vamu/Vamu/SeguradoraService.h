//
//  SeguradoraService.h
//  Vamu
//
//  Created by Guilherme Augusto on 18/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "Seguradora.h"

@interface SeguradoraService : BaseService

-(void) buscarSeguradoras;

@end

@interface NSObject (SeguradoraServiceDelegate)

-(void) erroAoBuscarSeguradoras;
-(void) retornouSeguradoras;

@end