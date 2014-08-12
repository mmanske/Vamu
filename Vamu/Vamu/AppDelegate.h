//
//  AppDelegate.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHelper.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Participante.h"
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString *macAddressDevice;
@property (nonatomic, strong) Participante *participanteLogado;
@property (nonatomic, strong) MKRoute *rota;

@property (nonatomic, strong) NSMutableArray *motoristas;
@property (nonatomic, strong) NSMutableArray *grupos;
@property (nonatomic, strong) NSMutableArray *solicitacoes;
@property (nonatomic, strong) NSMutableArray *aceitacoes;
@property (nonatomic, strong) NSMutableArray *negacoes;

@property (nonatomic, strong) NSMutableArray *desembarqueCarona;
@property (nonatomic, strong) NSMutableArray *desembarqueMotorista;
@property (nonatomic, strong) NSMutableArray *finalizacaoViagem;

@property (nonatomic, strong) NSMutableString *nomeOrigem;
@property (nonatomic, strong) NSMutableString *nomeDestino;
@property (nonatomic, strong) NSString *numeroVersao;
@property (nonatomic, strong) NSNumber *distanciaPercorrida;
@property (nonatomic, strong) CLLocation *locationCarona;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (UINavigationController*) getRootNavigationController;

@end
