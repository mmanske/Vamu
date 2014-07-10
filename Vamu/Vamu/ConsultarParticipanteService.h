//
//  ConsultarParticipanteService.h
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "Participante.h"

@interface ConsultarParticipanteService : BaseService

-(void) consultarParticipante:(NSString*) codParticipante;

@end

@interface NSObject (ConsultarParticipanteServiceDelegate)

-(void) onRetornouParticipante:(Participante*) participante;

@end