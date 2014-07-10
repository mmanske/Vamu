//
//  RotaService.h
//  Vamu
//
//  Created by Guilherme Augusto on 24/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseService.h"
#import "Participante.h"
#import <MapKit/MapKit.h>
#import "Rota.h"
#import "Ponto.h"
#import "TrajetoFavorito.h"

@interface RotaService : BaseService

-(void) enviarRota:(Rota*) rota participante:(Participante*) participante;
-(void) salvarDestinoFavorito:(TrajetoFavorito*) destino;
-(void) buscarTrajetoFavorito;
-(void) cancelarDestinoFavorito:(TrajetoFavorito*) destino;

@end

@interface NSObject (RotaServiceDelegate)

-(void) cancelouRotaFavorita;
-(void) salvouRota:(NSNumber*) codViagem;
-(void) salvouRotaFavorita;
-(void) rotaFalhaAoSalvarNotificacoes;
-(void) rotaFalhaAoSalvarViagem;
-(void) rotaFalhaJSon;

@end