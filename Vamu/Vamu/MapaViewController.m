//
//  MapaViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 12/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "MapaViewController.h"
#import "MotoristaAtivo.h"
#import "MotoristaPin.h"
#import "PedirCaronaButton.h"
#import "CaronaService.h"
#import "SolicitacaoCarona.h"
#import "MensagemCancelamento.h"
#import "NotificacaoService.h"
#import "CustomActivityView.h"
#import "AceitacaoCarona.h"
#import "DesembarqueMotoristaView.h"
#import "ConsultarParticipanteService.h"
#import "BaixarImagemService.h"
#import "NegacaoCarona.h"
#import "CaronaDesembarcou.h"
#import "MotoristaDesembarcouCarona.h"
#import "FinalizacaoViagem.h"
#import "CustomAnnotation.h"
#import "PinInicioFim.h"
#import "CaronaPin.h"

#import "ResumoViagemService.h"
#import "ResumoMotoristaViewController.h"
#import "ResumoCaronaViewController.h"

@interface MapaViewController ()

@property BOOL statusInicial;
@property (nonatomic, strong) SolicitacaoView *solicitacaoView;
@property (nonatomic, strong) GrupoView *grupoView;
@property (nonatomic, strong) Participante *participanteLogado;
@property (nonatomic, strong) NSMutableArray *motoristas;
@property (nonatomic, strong) CaronaService *caronaService;
@property (nonatomic, strong) SolicitacaoCarona *solicitacaoRecusada;
@property (nonatomic, strong) NotificacaoService *notificacaoService;
@property (nonatomic, strong) NSMutableArray *pinsMapa;
@property (nonatomic, strong) NSMutableArray *coordenadas;
@property (nonatomic, strong) NSMutableArray *caronas;
@property (nonatomic, strong) CustomActivityView *ampulheta;
@property (nonatomic, strong) ConsultarParticipanteService *consultarPartService;
@property (nonatomic, strong) BaixarImagemService *baixarImagemService;
@property (nonatomic, strong) Participante *motoristaSolicitado;
@property (nonatomic, strong) DesembarqueCaronaView *desembarqueCaronaView;
@property (strong, nonatomic) ResumoViagemService *resumoService;

@property (strong, nonatomic) NSDictionary *dicResumoCarona;
@property (strong, nonatomic) NSDictionary *dicResumoMotorista;

@end

@implementation MapaViewController

@synthesize mapa;
@synthesize rota;
@synthesize viewVerGrupos;
@synthesize lblVerGrupos;
@synthesize imgVerGrupos;
@synthesize btnVerGrupos;
@synthesize statusInicial;
@synthesize grupoView;
@synthesize participanteLogado;
@synthesize motoristas;
@synthesize caronaService;
@synthesize solicitacaoView;
@synthesize solicitacaoRecusada;
@synthesize notificacaoService;
@synthesize pinsMapa;
@synthesize coordenadas;
@synthesize ampulheta;
@synthesize caronas;
@synthesize consultarPartService;
@synthesize baixarImagemService;
@synthesize motoristaSolicitado, imgTipoParticipange;
@synthesize lblDestino, lblOrigem, lblNomeParticipante, imgParticipante;
@synthesize desembarqueCaronaView;
@synthesize resumoService;
@synthesize dicResumoCarona;
@synthesize dicResumoMotorista, locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.exibirNavigationBar = YES;
    
    motoristas = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Atualizar Mapa"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Solicitacao Recebida"
                                               object:nil];
    
    rota = [AppHelper getRota];
    participanteLogado = [AppHelper getParticipanteLogado];
    
    lblNomeParticipante.text = participanteLogado.nome;
    
    lblDestino.text = [AppHelper getNomeDestino];
    
    caronaService = [CaronaService new];
    caronaService.delegate = self;
    
    notificacaoService = [NotificacaoService new];
    notificacaoService.delegate = self;
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 1;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [AppHelper getParticipanteLogado].cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    
    imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];

    if ([[AppHelper getParticipanteLogado].motorista boolValue]) {
        imgTipoParticipange.image = [UIImage imageNamed:@"ico-indica-motorista_4.png"];
    } else {
        imgTipoParticipange.image = [UIImage imageNamed:@"ico-indica-carona_4.png"];
    }
    
    self.title = @"Mapa";
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    
    
    mapa.mapType = MKMapTypeStandard;
    mapa.delegate = self;
    mapa.showsUserLocation = YES;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01f, 0.01f);
    MKCoordinateRegion region = {mapa.userLocation.coordinate, span};
    MKCoordinateRegion regionThatFits = [mapa regionThatFits:region];
    
    [mapa setRegion:regionThatFits animated:NO];
    [mapa setMapType:MKMapTypeStandard];
    if (rota) {
        
        NSUInteger pointCount = rota.polyline.pointCount;
        CLLocationCoordinate2D *routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
        [rota.polyline getCoordinates:routeCoordinates range:NSMakeRange(0, pointCount)];
        
        float iniLat, fimLat, iniLong, fimLong = 0;
        
        iniLat = routeCoordinates[0].latitude;
        iniLong = routeCoordinates[0].longitude;
        fimLat = [[AppHelper getParticipanteLogado].latitudeFinal floatValue];
        fimLong = [[AppHelper getParticipanteLogado].longitudeFinal floatValue];
        
        CLLocation *locationInicial = [[CLLocation new] initWithLatitude:iniLat longitude:iniLong];
        CLLocation *locationFinal   = [[CLLocation new] initWithLatitude:fimLat longitude:fimLong];
        
        PinInicioFim *pinInicio = [[PinInicioFim new] initInLocation:locationInicial inicio:YES];
        PinInicioFim *pinFim    = [[PinInicioFim new] initInLocation:locationFinal inicio:NO];
        
        [mapa addAnnotation:pinInicio];
        [mapa addAnnotation:pinFim];
        
        [mapa addOverlay:rota.polyline level:MKOverlayLevelAboveRoads];
    }
    
    solicitacaoView = [[SolicitacaoView alloc] iniciar];
    solicitacaoView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [solicitacaoView setHidden:YES];
    solicitacaoView.alpha = 0.0f;
    solicitacaoView.delegate = self;
    [self.view addSubview:solicitacaoView];
    
    if (![participanteLogado.motorista isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        grupoView = [[GrupoView alloc] iniciar];
        grupoView.center = CGPointMake(self.view.frame.size.width / 2, viewVerGrupos.frame.origin.y + viewVerGrupos.frame.size.height + 135);
        [grupoView setHidden:YES];
        grupoView.alpha = 0.0f;
        
        [viewVerGrupos setHidden:NO];
        [lblVerGrupos setHidden:NO];
        [imgVerGrupos setHidden:NO];
        [btnVerGrupos setHidden:NO];
        
        [self.view addSubview:grupoView];
    } else {
        [viewVerGrupos setHidden:YES];
        [lblVerGrupos setHidden:YES];
        [imgVerGrupos setHidden:YES];
        [btnVerGrupos setHidden:YES];
    }
    
    pinsMapa = [NSMutableArray new];
    coordenadas = [NSMutableArray new];
    caronas = [NSMutableArray new];
    
    ampulheta = [CustomActivityView new];
    
    consultarPartService = [ConsultarParticipanteService new];
    consultarPartService.delegate = self;
    
    baixarImagemService = [BaixarImagemService new];
    baixarImagemService.delegate = self;
    
    desembarqueCaronaView = [[DesembarqueCaronaView alloc] iniciar];
    desembarqueCaronaView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 100);
    desembarqueCaronaView.delegate = self;
    desembarqueCaronaView.lblKM.text = [NSString stringWithFormat:@"0 Km"];
    [self.view addSubview:desembarqueCaronaView];
    
    [desembarqueCaronaView setHidden:YES];
    
    resumoService = [ResumoViagemService new];
    resumoService.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[[AppHelper getParticipanteLogado].latitudeAtual floatValue] longitude:[[AppHelper getParticipanteLogado].longitudeAtual floatValue]];
    [self getAddressFromCurruntLocation:location];
    
    Configuracao *config = [Configuracao alloc];
    NSArray *configs = [Configuracao getAll];
    if ([configs count] > 0) {
        config = [configs objectAtIndex:0];
        [mapa setCenterCoordinate:CLLocationCoordinate2DMake(config.ultLatitude, config.ultLongitude) animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLocalizacaoClick:(id)sender {
    MKCoordinateRegion region = {mapa.userLocation.coordinate, mapa.region.span};
    MKCoordinateRegion regionThatFits = [mapa regionThatFits:region];
    
    [mapa setRegion:regionThatFits animated:YES];
}

- (IBAction)btnZoomInClick:(id)sender {
    MKCoordinateRegion region = mapa.region;
    
    region.span.latitudeDelta /= 4;
    region.span.longitudeDelta /= 4;
    
    [mapa setRegion:region animated:YES];
}

- (IBAction)btnZoomOutClick:(id)sender {
    MKCoordinateRegion region = mapa.region;
    
    region.span.latitudeDelta *= 4;
    region.span.longitudeDelta *= 4;
    
    //Span Máximo
    if (region.span.latitudeDelta < 166.785235 && region.span.longitudeDelta < 135.773823) {
        [mapa setRegion:region animated:YES];
    }
}

- (IBAction)btnVerGruposClick:(id)sender {
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Atualizar Grupos" object:self];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (statusInicial) {
                             [self.btnVerGrupos setImage:[UIImage imageNamed:@"ico-btn-vergrupos_5.png"] forState:UIControlStateNormal];
                         } else {
                             [self.btnVerGrupos setImage:[UIImage imageNamed:@"ico-btn-vermapas_5.png"] forState:UIControlStateNormal];
                         }
                         
                         self.viewVerGrupos.frame = CGRectMake(statusInicial ? 0 : 160, viewVerGrupos.frame.origin.y, viewVerGrupos.frame.size.width, viewVerGrupos.frame.size.height);
                         self.btnVerGrupos.frame  = CGRectMake(statusInicial ? 112 : 15, btnVerGrupos.frame.origin.y, btnVerGrupos.frame.size.width, btnVerGrupos.frame.size.height);
                         self.lblVerGrupos.frame  = CGRectMake(statusInicial ? 8 : 60, lblVerGrupos.frame.origin.y, lblVerGrupos.frame.size.width, lblVerGrupos.frame.size.height);
                         lblVerGrupos.text = statusInicial ? @"Ver Grupos" : @"Ver Mapa";
                         imgVerGrupos.image = statusInicial ? [UIImage imageNamed:@"btn-vergrupos_5.png"] : [UIImage imageNamed:@"btn-vermapas_5.png"];
                     }
                     completion:^(BOOL finished){
                         if (statusInicial) {
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  grupoView.alpha = 0.0f;
                                              }
                                              completion:^(BOOL finished){
                                                  [grupoView setHidden:YES];
                                              }];
                         } else {
                             [grupoView atualizarGrupos];
                             [grupoView setHidden:NO];
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  grupoView.alpha = 1.0f;
                                              }
                                              completion:nil];
                         }
                         statusInicial = !statusInicial;
                     }];
}

#pragma mark - MapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    Configuracao *config = [Configuracao alloc];
    NSArray *configs = [Configuracao getAll];
    if ([configs count] > 0) {
        config = [configs objectAtIndex:0];
    } else {
        config = [Configuracao new];
    }
    
    CLLocation *ult = [[CLLocation alloc] initWithLatitude:config.ultLatitude longitude:config.ultLongitude];
    
    CLLocation *atu = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    
    CLLocationDistance distance = [ult distanceFromLocation:atu];
    
    NSNumber *distanciaPercorrida = [AppHelper getDistaciaPercorrida];
    
    float distanciaTotal = [distanciaPercorrida floatValue] + distance;
    
    [AppHelper setDistanciaPercorrida:[NSNumber numberWithFloat:distanciaTotal]];
    
    desembarqueCaronaView.lblKM.text = [NSString stringWithFormat:@"%.2f Km", distanciaTotal/1000];
    
    config.ultLatitude  = userLocation.coordinate.latitude;
    config.ultLongitude = userLocation.coordinate.longitude;
    
    [config save:nil];
    
    Ponto *ponto = [Ponto new];
    ponto.latitude = userLocation.coordinate.latitude;
    ponto.longitude = userLocation.coordinate.longitude;
    
    [coordenadas addObject:ponto];
    
    [[AppHelper getParticipanteLogado] setLatitudeAtual:[NSNumber numberWithFloat:userLocation.coordinate.latitude]];
    [[AppHelper getParticipanteLogado] setLongitudeAtual:[NSNumber numberWithFloat:userLocation.coordinate.longitude]];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    if ([[[AppHelper getParticipanteLogado] motorista] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        renderer.strokeColor = [UIColor colorWithRed:0.3 green:0.3 blue:1.0 alpha:0.7];
    } else {
        renderer.strokeColor = [UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:0.7];
    }
    renderer.lineWidth = 5.0;
    return renderer;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MotoristaPin class]]) {
        NSString *identifier = [NSString stringWithFormat:@"%@", ((MotoristaPin*) annotation).motoristaAtivo.codPessoa];
        
        MKAnnotationView *pinView = (MKAnnotationView*)[mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView) {
            
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.canShowCallout = NO;
            pinView.image = ((MotoristaPin*) annotation).imagem;
            pinView.draggable = YES;
            
        } else {
            pinView.annotation = annotation;
        }
        
        [pinView setFrame:CGRectMake(pinView.frame.origin.x, pinView.frame.origin.y, 46, 46)];
        
        return pinView;
    }
    
    if ([annotation isKindOfClass:[CaronaPin class]]) {
        NSString *identifier = @"caronaPin";
        
        MKAnnotationView *pinView = (MKAnnotationView*)[mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView) {
            
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.canShowCallout = NO;
            pinView.image = ((CaronaPin*) annotation).image;
            pinView.draggable = YES;
            
        } else {
            pinView.annotation = annotation;
        }
        
        [pinView setFrame:CGRectMake(pinView.frame.origin.x, pinView.frame.origin.y, 46, 46)];
        
        return pinView;
    }
    
    if ([annotation isKindOfClass:[PinInicioFim class]]) {
        NSString *identifier = ((PinInicioFim*) annotation).ini ? @"pinInicio" : @"pinFim";
        
        MKAnnotationView *pinView = (MKAnnotationView*)[mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!pinView) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pinView.draggable = NO;
            pinView.image = ((PinInicioFim*) annotation).imagem;
            pinView.canShowCallout = NO;
        } else {
            pinView.annotation = annotation;
        }
        
        [pinView setFrame:CGRectMake(pinView.frame.origin.x, pinView.frame.origin.y, 25, 25)];
        
        return pinView;
    }
    
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        NSString *identifier = @"userPin";
        
        MKAnnotationView *pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        if ([participanteLogado.motorista isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            pinView.image = [UIImage imageNamed:@"pin-mapa-azulescuro_5.png"];
        } else {
            pinView.image = [UIImage imageNamed:@"pin-mapa-verde_5.png"];
        }
        
        [pinView setFrame:CGRectMake(pinView.frame.origin.x, pinView.frame.origin.y, 46, 46)];
        
        pinView.canShowCallout = NO;
        
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[MotoristaPin class]]) {
        
        EnviarSolicitacaoView *calloutView = (EnviarSolicitacaoView *)[[[NSBundle mainBundle] loadNibNamed:@"EnviarSolicitacaoView" owner:self options:nil] objectAtIndex:0];
        calloutView.delegate = self;
        
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        calloutView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        
        MotoristaAtivo *motorista = [(MotoristaPin*)[view annotation] motoristaAtivo];
        [calloutView setMotorista: motorista];
        [calloutView setCodigo:[NSString stringWithFormat:@"%@", motorista.codPessoa]];
        [calloutView iniciar];
        
        [self.view addSubview:calloutView];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    for (UIView *subview in view.subviews ){
        [subview removeFromSuperview];
    }
}

#pragma mark - Notification

- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Atualizar Mapa"]) {
        [self atualizarMapa];
    }
    
    if ([[notification name] isEqualToString:@"Solicitacao Recebida"]) {
        [self exibirSolicitacao];
    }
}

-(void) exibirSolicitacao{
    if ([[AppHelper getAceitacoes] count] > 0) {
        AceitacaoCarona *aceitacao = [[AppHelper getAceitacoes] objectAtIndex:0];
        
        SolicitacaoAceitaView *solicitacaoAceitaView = [[SolicitacaoAceitaView alloc] exibirSolicitacao:aceitacao];
        solicitacaoAceitaView.delegate = self;
        solicitacaoAceitaView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [solicitacaoAceitaView setHidden:NO];
        
        [solicitacaoAceitaView carregarImagemMotorista];
        
        [notificacaoService confirmacaoLeitura:aceitacao.codNotificacao];
        
        [self.view addSubview:solicitacaoAceitaView];
        
    }
    
    if ([[AppHelper getNegacoes] count] > 0) {
        NegacaoCarona *negacao = [[AppHelper getNegacoes] objectAtIndex:0];
        
        CaronaSolicitacaoNegada *solicitacaoNegadaView = [[CaronaSolicitacaoNegada alloc] exibirSolicitacao:negacao];
        solicitacaoNegadaView.delegate = self;
        solicitacaoNegadaView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [solicitacaoNegadaView setHidden:NO];
        
        [solicitacaoNegadaView carregarImagemMotorista];
        
        [notificacaoService confirmacaoLeitura:negacao.codNotificacao];
        
        [self.view addSubview:solicitacaoNegadaView];
        
    }
    
    if ([[AppHelper getSolicitacoes] count] > 0) {
        
        if ([[AppHelper getParticipanteLogado].motorista isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            
            SolicitacaoCarona *solicitacao = [[AppHelper getSolicitacoes] objectAtIndex:0];

            solicitacaoView.lblNomeParticipante.text = solicitacao.remetente.nome;
            solicitacaoView.lblNumViajens.text       = [NSString stringWithFormat:@"%@ viagem(ns)", solicitacao.numViagens];
            solicitacaoView.solicitacao = solicitacao;
            [solicitacaoView carregarImagemCarona];
            
            [solicitacaoView setHidden:NO];
            [UIView animateWithDuration:0.3
                             animations:^{
                                 solicitacaoView.alpha = 1.0f;
                             }
                             completion:nil];
            
            [notificacaoService confirmacaoLeitura:solicitacao.codNotificacao];
        }
    }
    
    if ([[AppHelper getDesembarqueCarona] count] > 0) {
        CaronaDesembarcou *desembarque = [[AppHelper getDesembarqueCarona] objectAtIndex:0];
        [notificacaoService confirmacaoLeitura:desembarque.codNotificacao];
    }
    
    if ([[AppHelper getDesembarqueMotorista] count] > 0) {
        MotoristaDesembarcouCarona *desembarque = [[AppHelper getDesembarqueMotorista] objectAtIndex:0];
        [notificacaoService confirmacaoLeitura:desembarque.codNotificacao];
    }
    
    if ([[AppHelper getFinalizacaoViagem] count] > 0) {
        FinalizacaoViagem *finalizacao = [[AppHelper getFinalizacaoViagem] objectAtIndex:0];
        [notificacaoService confirmacaoLeitura:finalizacao.codNotificacao];
        
        
        if (participanteLogado && [participanteLogado.motorista boolValue]) {
            [AppHelper setDistanciaPercorrida:nil];
            [ampulheta exibir];
            [resumoService resumoViagemMotorista];
//            [self performSegueWithIdentifier:@"sgResumoMotorista" sender:nil];
        }
    }
}

-(void) atualizarMapa{
    [mapa removeAnnotations:pinsMapa];
    [pinsMapa removeAllObjects];
    motoristas = [AppHelper getMotoristas];
    for (MotoristaAtivo *motorista in motoristas) {
        MotoristaPin *pin = [[MotoristaPin alloc] initWithMotorista:motorista];
        [pinsMapa addObject:pin];
//        NSLog(@"Motorista %f - %f",[motorista.latitude floatValue], [motorista.longitude floatValue] );
    }
    
    if ([[AppHelper getParticipanteLogado].motorista boolValue]) {
        for (Participante* carona in caronas) {
            CaronaPin *caronaPin = [[CaronaPin new] initWithCarona:carona];
            [pinsMapa addObject:caronaPin];
//            NSLog(@"Carona: %f - %f",[carona.latitudeAtual floatValue], [carona.longitudeAtual floatValue] );
        }
        
        //CaronaPin *caronaPin = [[CaronaPin new] initInLocation:[AppHelper getLocationCarona]];
        
    }
    
    [mapa addAnnotations:pinsMapa];
}

#pragma mark - EnviarSolicitacaoViewDelegate

-(void)solicitouCarona:(NSString *)cod{
    [caronaService solicitarCarona:cod destino:[AppHelper getNomeDestino]];
}

#pragma mark - Vamu

-(void) pedirCarona:(PedirCaronaButton*) sender{
    [caronaService solicitarCarona:[NSString stringWithFormat:@"%@", sender.motoristaAtivo.codPessoa] destino:[AppHelper getNomeDestino]];
}

#pragma mark - SolicitacaoViewDelegate

-(void)solicitacaoAceita{

}

-(void)aceitarSolicitacao:(SolicitacaoCarona *)solicitacao{
    
    float altura = self.view.frame.size.height - 25;

    DesembarqueMotoristaView *desembarqueMotorista = [[DesembarqueMotoristaView alloc] iniciarSolicitacao:solicitacao];
    desembarqueMotorista.center = CGPointMake(self.view.frame.size.width / 2, altura - ([caronas count] * 51));
    desembarqueMotorista.delegate = self;
    
    [self.view addSubview:desembarqueMotorista];
    
    [caronas addObject:solicitacao.remetente];
    
    //NSLog(@"Carona1: %f - %f",[solicitacao.remetente.latitudeAtual floatValue], [solicitacao.remetente.longitudeAtual floatValue] );
    //NSLog(@"Carona2: %f - %f",[solicitacao.latitudeRemetente floatValue], [solicitacao.longitudeRemetente floatValue] );
    if (solicitacao.latitudeRemetente) {
        solicitacao.remetente.latitudeAtual = [NSNumber numberWithFloat:[solicitacao.latitudeRemetente floatValue]];
        solicitacao.remetente.longitudeAtual = [NSNumber numberWithFloat:[solicitacao.longitudeRemetente floatValue]];
        
    }
    
    [caronaService aceitarSolicitacao:solicitacao];
    [UIView animateWithDuration:0.3
                     animations:^{
                         solicitacaoView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [solicitacaoView setHidden:YES];
                     }];
    [notificacaoService confirmacaoLeitura:solicitacao.codNotificacao];
}

-(void)recusarSolicitacao:(SolicitacaoCarona *)solicitacao{
    solicitacaoRecusada = solicitacao;
    [caronaService mensagensCancelamento];
}

-(void)mensagensCancelamento:(NSArray *)mensagens{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Carro lotado", @"Mudei o trajeto", @"Não posso agora", nil];
    [action showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableString *mensagem = [NSMutableString new];
    BOOL envia = YES;
    
    switch (buttonIndex) {
        case 0: mensagem = [NSMutableString stringWithString:@"Carro Lotado"];
            break;
            
        case 1: mensagem = [NSMutableString stringWithString:@"Mudei o trajeto"];
            
            break;
            
        case 2: mensagem = [NSMutableString stringWithString:@"Não posso agora"];
            break;

        case 3: mensagem = [NSMutableString stringWithString:@"Cancelar"];
            envia = NO;
            break;
            
        default:
            break;
    }
    
    if (envia) {
        solicitacaoRecusada.mensagem = mensagem;
        [caronaService recusarSolicitacao:solicitacaoRecusada];
        [notificacaoService confirmacaoLeitura:solicitacaoRecusada.codNotificacao];
        [UIView animateWithDuration:0.3
                         animations:^{
                             solicitacaoView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             [solicitacaoView setHidden:YES];
                         }];
    }
}

#pragma mark - DesembarqueCaronaViewDelegate

-(void)desembarquei{
    [AppHelper setDistanciaPercorrida:nil];
    [ampulheta exibir];
    [resumoService resumoViagemCarona];
//    [self performSegueWithIdentifier:@"sgResumoCarona" sender:nil];
}

-(void)desembarqueConcluido{
    [AppHelper setDistanciaPercorrida:nil];
    [ampulheta esconder];
}

-(void) embarqueConcluido{
    //Confirmou o embarque - Ações para carona
    
    [desembarqueCaronaView setHidden:NO];
    [viewVerGrupos removeFromSuperview];
}

#pragma mark - DesembarqueMotoristaViewDelegate

-(void)desembarcou:(Participante *)participante{
//    [[[UIAlertView alloc] initWithTitle:@"Viagem" message:[NSString stringWithFormat:@"Viagem do participante %@ encerrada com sucesso!", participante.nome] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)embarcou:(Participante *)participante{
    //Confirmou o embarque - Ações para motorista
   // NSLog(@"teste");
}

-(void)cancelouEmbarque:(Participante *)participante{

}

#pragma mark - ConsultarParticipanteServiceDelegate

-(void)onRetornouParticipante:(Participante *)participante{
    [baixarImagemService baixarImagemDePessoa:participante.cpf];
    motoristaSolicitado = participante;
}

#pragma mark - BaixarImagemServiceDelegate

-(void)finalizaBaixarImagem{
    
}

#pragma mark - SolicitacaoAceitaViewDelegate

-(void)confirmarSolicitacao:(AceitacaoCarona *)solicitacao{
    [notificacaoService confirmacaoLeitura:solicitacao.codNotificacao];
    
    CaronaConfirmarEmbarqueView *confirmarEmbarque = [[CaronaConfirmarEmbarqueView alloc] exibirSolicitacao:solicitacao];
    confirmarEmbarque.delegate = self;
    confirmarEmbarque.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [confirmarEmbarque setHidden:NO];
    
    [confirmarEmbarque carregarImagemMotorista];
    
    [self.view addSubview:confirmarEmbarque];
}

#pragma mark - NegacaoCaronaDelegate

-(void)confirmarNegada:(NegacaoCarona *)solicitacao{
    [notificacaoService confirmacaoLeitura:solicitacao.codNotificacao];
}

#pragma mark - ConfirmaEmbarqueDelegate

-(void)embarcouCarona:(AceitacaoCarona *)solicitacao{
    [caronaService caronaConfirmarEmbarque:solicitacao];
}

-(void)cancelouCarona:(AceitacaoCarona *)solicitacao{
    [caronaService caronaCancelaEmbarque:solicitacao];
}

-(void)getAddressFromCurruntLocation:(CLLocation *)location{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             
             if ([placemark thoroughfare].length > 0 && [placemark locality].length > 0 && [placemark administrativeArea].length > 0) {
                 NSString *endereco = [NSString stringWithFormat:@"%@, %@, %@",[placemark thoroughfare],[placemark locality],[placemark administrativeArea]];
                 lblOrigem.text = endereco;
                 [AppHelper setNomeOrigem:[NSMutableString stringWithString:endereco]];
             } else {
                 lblOrigem.text = @"";
                 [AppHelper setNomeOrigem:[NSMutableString stringWithString:@""]];
             }
             
         }
     }];
}

#pragma mark - ResumoServiceDelegate

-(void)onRetornouResumoCarona:(NSDictionary *)dicResumo{
    [ampulheta esconder];
    dicResumoCarona = dicResumo;
    [self performSegueWithIdentifier:@"sgResumoCarona" sender:nil];
}

-(void)onRetornouREsumoMotorista:(NSDictionary *)dicResumo{
    [ampulheta esconder];
    dicResumoMotorista = dicResumo;
    [self performSegueWithIdentifier:@"sgResumoMotorista" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sgResumoCarona"]) {
        ResumoCaronaViewController *view = (ResumoCaronaViewController*)segue.destinationViewController;
        view.dicionarioResumo = dicResumoCarona;
    }
    
    if ([segue.identifier isEqualToString:@"sgResumoMotorista"]) {
        ResumoMotoristaViewController *view = (ResumoMotoristaViewController*)segue.destinationViewController;
        view.dicionarioResumo = dicResumoMotorista;
    }
}

@end
