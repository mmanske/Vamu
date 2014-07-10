//
//  MapaGoogleViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 22/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Configuracao.h"
#import "BaseViewController.h"
#import "MenuViewController.h"
#import "REFrostedViewController.h"
#import <MapKit/MapKit.h>
#import "Participante.h"

@interface MapaGoogleViewController : BaseViewController<MenuViewControllerDelegate, REFrostedViewControllerDelegate>

@property (strong, nonatomic) Participante *participanteLogado;
@property (strong, nonatomic) MKRoute *rota;

@end
