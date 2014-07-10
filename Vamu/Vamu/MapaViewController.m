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
@synthesize motoristaSolicitado;

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
    
    caronaService = [CaronaService new];
    caronaService.delegate = self;
    
    notificacaoService = [NotificacaoService new];
    notificacaoService.delegate = self;
    
    self.title = @"Mapa";
    
    mapa.mapType = MKMapTypeStandard;
    mapa.delegate = self;
    mapa.showsUserLocation = YES;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01f, 0.01f);
    MKCoordinateRegion region = {mapa.userLocation.coordinate, span};
    MKCoordinateRegion regionThatFits = [mapa regionThatFits:region];
    
    [mapa setRegion:regionThatFits animated:NO];
    [mapa setMapType:MKMapTypeStandard];
    if (rota) {
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
        grupoView.center = CGPointMake(self.view.frame.size.width / 2, 244);
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
}

-(void)viewDidAppear:(BOOL)animated{
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
            pinView.canShowCallout = YES;
            pinView.image = ((MotoristaPin*) annotation).imagem;
            pinView.draggable = YES;
            
            PedirCaronaButton *btnPedirCarona = [PedirCaronaButton buttonWithType:UIButtonTypeInfoLight];
            [btnPedirCarona addTarget:self action:@selector(pedirCarona:) forControlEvents:UIControlEventTouchUpInside];
            btnPedirCarona.motoristaAtivo = ((MotoristaPin*) annotation).motoristaAtivo;
            
            pinView.rightCalloutAccessoryView = btnPedirCarona;

        } else {
            pinView.annotation = annotation;
        }
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
        
        pinView.canShowCallout = NO;
//        pinView.calloutOffset = CGPointMake(0, 32);
        
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    if([view.annotation isKindOfClass:[MotoristaPin class]]) {
//        EnviarSolicitacaoView *calloutView = (EnviarSolicitacaoView *)[[[NSBundle mainBundle] loadNibNamed:@"EnviarSolicitacaoView" owner:self options:nil] objectAtIndex:0];
//        calloutView.lblNomeParticipante.text = @"Guilherme";
//        [calloutView iniciar];
//        CGRect calloutViewFrame = calloutView.frame;
//        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
//        calloutView.frame = calloutViewFrame;
//        [view addSubview:calloutView];
//    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
        [consultarPartService consultarParticipante:aceitacao.remetente.codParticipante];
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
    }
    [mapa addAnnotations:pinsMapa];
}

#pragma mark - Vamu

-(void) pedirCarona:(PedirCaronaButton*) sender{
    [caronaService solicitarCarona:[NSString stringWithFormat:@"%@", sender.motoristaAtivo.codPessoa] destino:[AppHelper getNomeDestino]];
}

#pragma mark - SolicitacaoViewDelegate

-(void)solicitacaoAceita{
//    DesembarqueCaronaView *desembarqueCaronaView = [[DesembarqueCaronaView alloc] iniciar];
//    desembarqueCaronaView.center = CGPointMake(self.view.frame.size.width / 2, );
//    desembarqueCaronaView.delegate = self;
//    desembarqueCaronaView.carona = solicitacao.remetente;
}

-(void)aceitarSolicitacao:(SolicitacaoCarona *)solicitacao{
    
    float altura = self.view.frame.size.height - 25;

    DesembarqueMotoristaView *desembarqueMotorista = [[DesembarqueMotoristaView alloc] iniciarSolicitacao:solicitacao];
    desembarqueMotorista.center = CGPointMake(self.view.frame.size.width / 2, altura - ([caronas count] * 51));
    desembarqueMotorista.delegate = self;
    
    [self.view addSubview:desembarqueMotorista];
    
    [caronas addObject:solicitacao.remetente];
    
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
    [ampulheta exibir];
    [caronaService desembarqueCarona:[AppHelper getParticipanteLogado]];
}

-(void)desembarqueConcluido{
    [ampulheta esconder];
    //ir para a tela de resumo da viagem (que não existe)
}

#pragma mark - DesembarqueMotoristaViewDelegate

-(void)desembarcou:(Participante *)participante{
    
}

-(void)embarcou:(Participante *)participante{
    
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

@end
