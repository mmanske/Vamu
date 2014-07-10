//
//  DefinirTrajetoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 25/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "DefinirTrajetoViewController.h"
#import "LeftMenuVC.h"
#import "AppHelper.h"
#import "CustomActivityView.h"
#import "RotaService.h"
#import "Rota.h"
#import "Ponto.h"

@interface DefinirTrajetoViewController ()

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *rotas;
@property (strong, nonatomic) MKRoute *rotaSelecionada;
@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) RotaService *rotaService;
@property (strong, nonatomic) MKRoute *rotaFavorita;
@property (strong, nonatomic) PlacesService *placeServices;
@property (nonatomic, strong) NSMutableArray *lugares;
@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;
@property (nonatomic) NSArray *formItems;


@end

@implementation DefinirTrajetoViewController

@synthesize window;
@synthesize rotas;
@synthesize tabela;
@synthesize edtDestino;
@synthesize edtOrigem;
@synthesize rotaSelecionada;
@synthesize imgMotorista;
@synthesize lblNomeMotorista;
@synthesize participanteLogado;
@synthesize imgIcoIndicacao;
@synthesize lblTipo;
@synthesize carona;
@synthesize veiculo;
@synthesize ampulheta;
@synthesize rotaService;
@synthesize rotaFavorita;
@synthesize placeServices, enhancedKeyboard, formItems;
@synthesize lugares = _lugares;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @" ";

    self.title = @"Definir Trajeto";
    
    participanteLogado = [AppHelper getParticipanteLogado];
    
    imgMotorista.layer.cornerRadius = imgMotorista.bounds.size.width/2;
    imgMotorista.layer.masksToBounds = YES;
    imgMotorista.layer.borderWidth = 2;
    imgMotorista.layer.borderColor = [UIColor whiteColor].CGColor;
    imgMotorista.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    lblTipo.text = @"";
    if (carona) {
        imgIcoIndicacao.image = [UIImage imageNamed:@"ico-indica-carona_5.png"];
        lblTipo.text = @"Carona";
    } else {
        imgIcoIndicacao.image = [UIImage imageNamed:@"ico-indica-motorista_5.png"];
        if (veiculo) {
            lblTipo.text = [NSString stringWithFormat:@"%@ - %@ - %@", veiculo.modelo, veiculo.placa, veiculo.ano];
        }
        
    }
    
    rotas = [NSMutableArray new];
    tabela.delegate = self;
    tabela.dataSource = self;
    edtOrigem.text  = @"Minha Localização Atual";
   // edtDestino.text = @"Avenida das Américas, Barra da Tijuca, Rio de Janeiro";
    [tabela registerClass:[RotaCell class] forCellWithReuseIdentifier:@"RotaCell"];
    
    if (participanteLogado) {
        lblNomeMotorista.text = participanteLogado.nome;
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", participanteLogado.cpf];
        NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
        imgMotorista.image = [UIImage imageWithContentsOfFile:imageFileName];

    }
    
    ampulheta = [CustomActivityView new];
    
    rotaService = [RotaService new];
    rotaService.delegate = self;
    
    _lugares = [NSMutableArray new];
    
    placeServices = [PlacesService new];
    placeServices.delegate = self;
    
    edtDestino.delegate = self;
    edtDestino.autoCompleteDataSource = self;
    edtDestino.autoCompleteDelegate = self;
    
    [edtDestino setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    
    [edtDestino registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class]
                       forCellReuseIdentifier:@"CustomCellId"];
    
    self.formItems = [NSArray arrayWithObjects:edtDestino, nil];
    self.enhancedKeyboard = [KSEnhancedKeyboard new];
    self.enhancedKeyboard.delegate = self;

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnIrClick:(id)sender {
    if (edtDestino.text.length <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"Definir Destino" message:@"Informa o destino da viagem" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    [ampulheta exibir];
    [rotas removeAllObjects];
    [tabela reloadData];
    [self obterRotas];
    [edtDestino resignFirstResponder];
}

- (IBAction)btnFavoritosClick:(id)sender {
    [ampulheta exibir];
    [rotas removeAllObjects];
    [tabela reloadData];
    [self obterRotasFavoritas];
    [tabela reloadData];
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

-(void) obterRotasFavoritas{
    NSArray *trajetosFavoritos = [TrajetoFavorito getAll];
    
    for (TrajetoFavorito *trajeto in trajetosFavoritos)
    {
        CLLocationCoordinate2D _srcCoord = CLLocationCoordinate2DMake(trajeto.latitude, trajeto.longitude);
        MKPlacemark *_srcMark = [[MKPlacemark alloc] initWithCoordinate:_srcCoord addressDictionary:nil];
        MKMapItem *_srcItem = [[MKMapItem alloc] initWithPlacemark:_srcMark];
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        
        request.source = [MKMapItem mapItemForCurrentLocation];
        
        request.destination = _srcItem;
        request.requestsAlternateRoutes = YES;
        
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:
         ^(MKDirectionsResponse *response, NSError *error) {
             
             if (!error) {
                 for (MKRoute *route in response.routes){
                     RotasVO *rotaVO = [RotasVO new];
                     rotaVO.rota = route;
                     rotaVO.trajetoFavorito = trajeto;
                     [rotas addObject:rotaVO];
                 }
                 [tabela reloadData];
             }
         }];
    }
    [ampulheta esconder];
}

-(void) obterRotas{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:edtDestino.text completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks)
        {
            CLLocationCoordinate2D _srcCoord = CLLocationCoordinate2DMake(aPlacemark.location.coordinate.latitude, aPlacemark.location.coordinate.longitude);
            MKPlacemark *_srcMark = [[MKPlacemark alloc] initWithCoordinate:_srcCoord addressDictionary:nil];
            MKMapItem *_srcItem = [[MKMapItem alloc] initWithPlacemark:_srcMark];
            
            MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
            
            request.source = [MKMapItem mapItemForCurrentLocation];
            
            request.destination = _srcItem;
            request.requestsAlternateRoutes = YES;
            
            MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
            
            [directions calculateDirectionsWithCompletionHandler:
             ^(MKDirectionsResponse *response, NSError *error) {
                 
                 if (!error) {
                     for (MKRoute *route in response.routes){
                         RotasVO *rotaVO = [RotasVO new];
                         rotaVO.rota = route;
                         [rotas addObject:rotaVO];
                     }
                     [tabela reloadData];
                     [ampulheta esconder];
                 }
             }];
        }
    }];
}

#pragma mark - SegueDelegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}


#pragma mark - Collection View Delegate

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RotaCell *cell = (RotaCell*)[tabela dequeueReusableCellWithReuseIdentifier:@"RotaCell" forIndexPath:indexPath];
    cell = [cell initWithRotaVO:[rotas objectAtIndex:indexPath.row] indexPath:indexPath delegate:self];
//    cell = [cell initWithRoute:[rotas objectAtIndex:indexPath.row] indexPath:indexPath delegate:self favorito:NO];
    return cell;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger qtd = [rotas count];
    return qtd;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - RotaCellDelegate

-(void)iniciarRota:(MKRoute *)rota{
    [ampulheta exibir];
    rotaSelecionada = rota;
    [AppHelper setRota:rota];
    
    Rota *rtRota = [Rota new];
    
    rtRota.descricao = rota.name;
    
    NSUInteger pointCount = rota.polyline.pointCount;
    CLLocationCoordinate2D *routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
    [rota.polyline getCoordinates:routeCoordinates range:NSMakeRange(0, pointCount)];
    for (int c=0; c < pointCount; c++)
    {
        if (c == pointCount - 1) {
            [[AppHelper getParticipanteLogado] setLatitudeFinal:[NSNumber numberWithFloat:routeCoordinates[c].latitude]];
            [[AppHelper getParticipanteLogado] setLongitudeFinal:[NSNumber numberWithFloat:routeCoordinates[c].longitude]];
        }
        
        Ponto *ponto = [Ponto new];
        ponto.latitude = routeCoordinates[c].latitude;
        ponto.longitude = routeCoordinates[c].longitude;
        ponto.ordem = c;
        
        [rtRota addPontosObject:ponto];
    }

    free(routeCoordinates);
    
    [AppHelper setNomeDestino:edtDestino.text];
    
    [rotaService enviarRota:rtRota participante:[AppHelper getParticipanteLogado]];
    
//    if ([[AppHelper getParticipanteLogado].motorista isEqualToNumber:[NSNumber numberWithBool:YES]]) {
//        [rotaService enviarRota:rtRota participante:[AppHelper getParticipanteLogado]];
//    } else {
//        [self salvouRota];
//    }
}

-(void)salvarRotaFavorita:(MKRoute *)rota{
    rotaFavorita = rota;
    UIAlertView *alertDescricao = [[UIAlertView alloc] initWithTitle:@"Trajeto" message:@"Descrição" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Ok", nil];
    alertDescricao.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertDescricao show];
    
}

-(void)removerRotaFavorita:(RotasVO *)rota{
    [ampulheta exibir];
    [rotaService cancelarDestinoFavorito:rota.trajetoFavorito];
}

#pragma mark - RotaServiceDelegate

-(void)cancelouRotaFavorita{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Trajeto" message:@"Destino Removido!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)salvouRota{
    [ampulheta esconder];
    NSUInteger indexes[] = {1, 2};
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
    [self.mainSlideMenu openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void)salvouRotaFavorita{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Trajeto" message:@"Destino Salvo Com Sucesso!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)rotaFalhaAoSalvarViagem{
    
}

-(void)rotaFalhaAoSalvarNotificacoes{
    
}

-(void)rotaFalhaJSon{
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [ampulheta exibir];
        UITextField *txt = [alertView textFieldAtIndex:0];
        TrajetoFavorito *trajeto = [TrajetoFavorito new];
        trajeto.participante = self.participanteLogado;
        trajeto.descricao    = [NSString stringWithFormat:@"%@", txt.text];
        
        NSUInteger pointCount = rotaFavorita.polyline.pointCount;
        CLLocationCoordinate2D *routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
        [rotaFavorita.polyline getCoordinates:routeCoordinates range:NSMakeRange(0, pointCount)];
        for (int c=0; c < pointCount; c++)
        {
            if (c == pointCount - 1) {
                trajeto.latitude  = routeCoordinates[c].latitude;
                trajeto.longitude = routeCoordinates[c].longitude;
            }
        }
        
        free(routeCoordinates);
        
        rotaFavorita = nil;
        
        [rotaService salvarDestinoFavorito:trajeto];
    }
}

#pragma mark - PlacesServiceDelegate

-(void)placesFound:(NSMutableArray *)lugares{
    _lugares = lugares;
    NSLog(@"%@", lugares);
}

-(void)noPlacesFound{
    [_lugares removeAllObjects];
}

#pragma mark - UIText

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (edtDestino.text.length > 3) {
        [placeServices consultar:edtDestino.text];
    } else {
        [_lugares removeAllObjects];
    }
    
    return YES;
}

#pragma mark - AutoComplete

-(NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string{
    return _lugares;
}

-(BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField shouldConfigureCell:(UITableViewCell *)cell withAutoCompleteString:(NSString *)autocompleteString withAttributedString:(NSAttributedString *)boldedString forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];
    if (textField == edtDestino) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 100.0), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == edtDestino) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 100.0), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}


- (void)nextDidTouchDown
{
    
    for (int i=0; i<[self.formItems count]; i++)
    {
        UITextField *field = [formItems objectAtIndex:i];
        if ([field isEditing] && i!=[self.formItems count]-1)
        {
            field = [formItems objectAtIndex:i+1];
            [field becomeFirstResponder];
            break;
        }
    }
}

- (void)doneDidTouchDown
{
    
    for (UITextField *field in self.formItems) {
        if ([field isEditing]) {
            [field resignFirstResponder];
            break;
        }
    }
}

- (void)previousDidTouchDown
{
    for (int i=0; i<[self.formItems count]; i++)
    {
        UITextField *field = [formItems objectAtIndex:i];
        if ([field isEditing] && i!=0)
        {
            
            field = [formItems objectAtIndex:i-1];
            [field becomeFirstResponder];
            break;
        }
    }
}

@end
