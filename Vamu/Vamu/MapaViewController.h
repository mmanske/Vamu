//
//  MapaViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 12/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Configuracao.h"
#import "BaseViewController.h"
#import "AppHelper.h"
#import "GrupoView.h"
#import "SolicitacaoView.h"
#import "EnviarSolicitacaoView.h"
#import "DesembarqueCaronaView.h"
#import "DesembarqueMotoristaView.h"
#import "SolicitacaoAceitaView.h"

@interface MapaViewController : BaseViewController<MKMapViewDelegate, SolicitacaoViewDelegate, UIActionSheetDelegate, DesembarqueCaronaViewDelegate, DesembarqueMotoristaViewDelegate, SolicitacaoAceitaViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapa;
@property (strong, nonatomic) IBOutlet UIButton *btnLocalizacao;
@property (strong, nonatomic) IBOutlet UIButton *btnZoomIn;
@property (strong, nonatomic) IBOutlet UIButton *btnZoomOut;
@property (strong, nonatomic) MKRoute *rota;
@property (strong, nonatomic) IBOutlet UIView *viewVerGrupos;
@property (strong, nonatomic) IBOutlet UILabel *lblVerGrupos;
@property (strong, nonatomic) IBOutlet UIImageView *imgVerGrupos;
@property (strong, nonatomic) IBOutlet UIButton *btnVerGrupos;
@property (strong, nonatomic) NSString *nomeDestino;

- (IBAction)btnLocalizacaoClick:(id)sender;
- (IBAction)btnZoomInClick:(id)sender;
- (IBAction)btnZoomOutClick:(id)sender;
- (IBAction)btnVerGruposClick:(id)sender;

@end
