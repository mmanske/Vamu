//
//  ResumoViagemService.h
//  Vamu
//
//  Created by Guilherme Augusto on 23/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"

typedef enum {
	ResumoCarona = 0,
	ResumoMotorista = 1
} TipoResumo;

@interface ResumoViagemService : BaseService

@property (nonatomic) TipoResumo tipoResumo;

-(void)resumoViagemCarona;
-(void)resumoViagemMotorista;

@end

@interface NSObject (ResumoViagemServiceDelegate)

-(void) onRetornouResumo:(NSDictionary*) dicResumo;

-(void) onRetornouResumoCarona:(NSDictionary*) dicResumo;
-(void) onRetornouREsumoMotorista:(NSDictionary*) dicResumo;

@end