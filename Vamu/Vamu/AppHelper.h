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

+(NSNumber*) getDistaciaPercorrida;
+(void) setDistanciaPercorrida:(NSNumber*) distancia;

+(NSMutableArray*) getMotoristas;
+(void) setMotoristas:(NSMutableArray*) motoristas;

+(NSMutableArray*) getGrupos;
+(void) setGrupos:(NSMutableArray*) grupos;

+(NSMutableArray*) getDesembarqueCarona;
+(void) setDesembarqueCarona:(NSMutableArray*) desembarques;

+(NSMutableArray*) getDesembarqueMotorista;
+(void) setDesembarqueMotorista:(NSMutableArray*) desembarques;

+(NSMutableArray*) getFinalizacaoViagem;
+(void) setFinalizacaoViagem:(NSMutableArray*) finalizacoes;

+(NSMutableArray*) getSolicitacoes;
+(void) setSolicitacoes:(NSMutableArray*) solicitacoes;

+(NSMutableArray*) getAceitacoes;
+(void) setAceitacoes:(NSMutableArray*) aceitacoes;

+(NSMutableArray*) getNegacoes;
+(void) setNegacoes:(NSMutableArray*) negacoes;

+(NSMutableArray*) getCaronas;
+(void) setCaronas:(NSMutableArray*) caronas;

+(MKRoute*)getRota;
+(void)setRota:(MKRoute*) rota;

+(NSMutableString*)getNomeDestino;
+(void)setNomeDestino:(NSMutableString*) nomeDestino;

+(NSMutableString*)getNomeOrigem;
+(void)setNomeOrigem:(NSMutableString*) nomeOrigem;

+(NSString*) getAbsolutePathForImageFile:(NSString*) fileName;
+(NSString*) limparCPF:(NSString*) cpf;

+(NSString*) deviceToken;
+(void)setDeviceToken:(NSString*)token;

+(void) salvarUsuario:(NSString*) cpf senha:(NSString*) senha;
+(NSDictionary*) carregaUsuarioLogado;
+(void) apagarUsuarioLogado;

+(void) setLocationCarona:(CLLocation*) location;
+(CLLocation*) getLocationCarona;


@end