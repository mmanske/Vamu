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

+(NSMutableArray *)getMotoristas{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] motoristas];
}

+(void)setMotoristas:(NSMutableArray *)motoristas{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setMotoristas:motoristas];
}

+(NSString*)getNomeDestino{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] nomeDestino];
}

+(void)setNomeDestino:(NSString*) nomeDestino{
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    [delegate setNomeDestino:nomeDestino];
}

+(NSString*) limparCPF:(NSString*) cpf {
    if (cpf) {
        NSString *cpfSemMascara = [cpf stringByReplacingOccurrencesOfString:@"." withString:@""];
        cpfSemMascara = [cpfSemMascara stringByReplacingOccurrencesOfString:@"-" withString:@""];
        return cpfSemMascara;
    }
    return nil;
}

@end