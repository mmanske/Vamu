//
//  AppHelper.m
//  ModelExample
//
//  Created by Franco Carbonaro on 14/12/10.
//  Copyright 2010 Franco Carbonaro. All rights reserved.
//

#import "AppHelper.h"
#import "AppDelegate.h"


#define kPreferencesName @"Vamu.plist"
static NSString * const userConfigFile = @"UserConfig";
static NSString * const userConfigFileComplete = @"UserConfig.plist";
static NSString * const DeviceTokenKey = @"DeviceToken";

@implementation AppHelper

+(NSString*)getPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:kPreferencesName];
    
}

+(NSString*) getAbsolutePathForImageFile:(NSString*) fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:fileName];
    
}

+ (NSManagedObjectContext *)mainManagedObjectContext {
	return [((AppDelegate *)[[UIApplication sharedApplication] delegate]) managedObjectContext];
}

+ (NSDictionary *)getPlistWithName: (NSString *)theName {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:theName ofType:@"plist"];
	NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	
	return plist;
}

+(NSNumber *)getDistaciaPercorrida{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    return [delegate distanciaPercorrida];
}

+(void)setDistanciaPercorrida:(NSNumber *)distancia{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setDistanciaPercorrida:distancia];
}

+ (NSDictionary *)getSettingsPlist {
	return [self getPlistWithName:@"Settings"];
}

+(NSString*)getMacAddressDevice {
    return [((AppDelegate *)[[UIApplication sharedApplication] delegate]) macAddressDevice];
}

+(UINavigationController*) getRootNavigationController {
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    return [delegate getRootNavigationController];
}

+(Participante *)getParticipanteLogado{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] participanteLogado];
}

+(void)setParticipanteLogado:(Participante *)participanteLogado{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setParticipanteLogado:participanteLogado];
}

+(MKRoute *)getRota{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] rota];
}

+(void)setRota:(MKRoute *)rota{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setRota:rota];
}

+(NSMutableArray *)getGrupos{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] grupos];
}

+(void)setGrupos:(NSMutableArray *)grupos{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setGrupos:grupos];
}

+(NSMutableArray *)getSolicitacoes{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] solicitacoes];
}

+(void)setSolicitacoes:(NSMutableArray *)solicitacoes{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setSolicitacoes:solicitacoes];
}

+(NSMutableArray *)getAceitacoes{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] aceitacoes];
}

+(void)setAceitacoes:(NSMutableArray *)aceitacoes{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setAceitacoes:aceitacoes];
}

+(NSMutableArray *)getNegacoes{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] negacoes];
}

+(void)setNegacoes:(NSMutableArray *)negacoes{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setNegacoes:negacoes];
}

+(NSMutableArray *)getMotoristas{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] motoristas];
}

+(void)setMotoristas:(NSMutableArray *)motoristas{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setMotoristas:motoristas];
}

+(NSMutableArray *)getCaronas{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] caronas];
}

+(void)setCaronas:(NSMutableArray *)caronas{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setCaronas:caronas];
}

+(NSMutableString*)getNomeDestino{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] nomeDestino];
}

+(void)setNomeDestino:(NSMutableString*) nomeDestino{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setNomeDestino:nomeDestino];
}

+(NSMutableString*)getNomeOrigem{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] nomeOrigem];
}

+(void)setNomeOrigem:(NSMutableString*) nomeOrigem{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setNomeOrigem:nomeOrigem];
}

+(NSMutableArray *)getDesembarqueCarona{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] desembarqueCarona];
}

+(NSMutableArray *)getDesembarqueMotorista{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] desembarqueMotorista];
}

+(NSMutableArray *)getFinalizacaoViagem{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] finalizacaoViagem];
}

+(void)setLocationCarona:(CLLocation *)location{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setLocationCarona:location];
}

+(CLLocation *)getLocationCarona{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] locationCarona];
}

+(void)setDesembarqueCarona:(NSMutableArray *)desembarques{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setDesembarqueCarona:desembarques];
}

+(void)setDesembarqueMotorista:(NSMutableArray *)desembarques{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setDesembarqueMotorista:desembarques];
}

+(void)setFinalizacaoViagem:(NSMutableArray *)finalizacoes{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setFinalizacaoViagem:finalizacoes];
}

+(NSString*) limparCPF:(NSString*) cpf {
    if (cpf) {
        NSString *cpfSemMascara = [cpf stringByReplacingOccurrencesOfString:@"." withString:@""];
        cpfSemMascara = [cpfSemMascara stringByReplacingOccurrencesOfString:@"-" withString:@""];
        return cpfSemMascara;
    }
    return nil;
}

+ (NSString*)deviceToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:DeviceTokenKey];
    //NSString *token = [(AppDelegate*)[[UIApplication sharedApplication] delegate] token];
	return token;
}

+ (void)setDeviceToken:(NSString*)token
{
//    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setToken:token];
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}


+(void) salvarUsuario:(NSString*) cpf senha:(NSString*) senha {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cpf, @"cpf", senha, @"senha", nil];
    NSString *fileName = [AppHelper getAbsolutePathForImageFile: userConfigFileComplete];
    [dic writeToFile:fileName atomically:YES];
}

+(NSDictionary*) carregaUsuarioLogado {
    NSString *fileName = [AppHelper getAbsolutePathForImageFile: userConfigFileComplete];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return dic;
}

+(void) apagarUsuarioLogado {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [AppHelper getAbsolutePathForImageFile: userConfigFileComplete];
    [fileManager removeItemAtPath:fileName error:nil];
}


@end