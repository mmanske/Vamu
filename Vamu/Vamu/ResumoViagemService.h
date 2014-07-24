//
//  ResumoViagemService.h
//  Vamu
//
//  Created by Guilherme Augusto on 23/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"

@interface ResumoViagemService : BaseService

-(void)resumoViagemCarona;
-(void)resumoViagemMotorista;

@end

@interface NSObject (ResumoViagemServiceDelegate)

-(void) onRetornouResumo:(NSDictionary*) dicResumo;

@end