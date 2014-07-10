//
//  AppHelper.h
//  ModelExample
//
//  Created by Franco Carbonaro on 23/09/10.
//  Copyright 2010 Franco Carbonaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Participante.h"
#import <MapKit/MapKit.h>

@interface AppHelper : NSObject {
	
}

+ (NSManagedObjectContext *)mainManagedObjectContext;

+ (NSDictionary *)getPlistWithName: (NSString *)theName;
+ (NSDictionary *)getSettingsPlist;

+(UINavigationController*) getRootNavigationController;

+(NSString*)getMacAddressDevice;

+(Participante*)getParticipanteLogado;
+(void)setParticipanteLogado:(Participante*) participanteLogado;

+(NSMutableArray*) getMotoristas;
+(void) setMotoristas:(NSMutableArray*) motoristas;

+(NSMutableArray*) getGrupos;
+(void) setGrupos:(NSMutableArray*) grupos;

+(NSMutableArray*) getSolicitacoes;
+(void) setSolicitacoes:(NSMutableArray*) solicitacoes;

+(NSMutableArray*) getAceitacoes;
+(void) setAceitacoes:(NSMutableArray*) aceitacoes;

+(MKRoute*)getRota;
+(void)setRota:(MKRoute*) rota;

+(NSString*)getNomeDestino;
+(void)setNomeDestino:(NSString*) nomeDestino;

+(NSString*) getAbsolutePathForImageFile:(NSString*) fileName;
+(NSString*) limparCPF:(NSString*) cpf;

@end