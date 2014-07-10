//
//  SelecionarTipoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 22/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "SelecionarTipoViewController.h"
#import "Veiculo.h"
#import "AppHelper.h"

@interface SelecionarTipoViewController (){
    BOOL carona;
    Veiculo *veiculoSelecionado;
}

@end

@implementation SelecionarTipoViewController

@synthesize btnCarona, btnMotorista, btnTrocarUsuario, btnTrocarVeiculo;
@synthesize imgFoto;
@synthesize lblCarro, lblNome, lblPlaca;
@synthesize participanteLogado;
@synthesize viewQtdCarona, viewQtdMotorista, lblQtdCarona, lblQtdMotorista;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.exibirNavigationBar = YES;
    
    btnTrocarUsuario.layer.cornerRadius = 8;
    btnTrocarVeiculo.layer.cornerRadius = 8;
    
    [self setRoundedView:viewQtdMotorista toDiameter:55];
    [self setRoundedView:viewQtdCarona toDiameter:55];
    
    participanteLogado = [AppHelper getParticipanteLogado];
    
    imgFoto.layer.cornerRadius = imgFoto.bounds.size.width/2;
    imgFoto.layer.masksToBounds = YES;
    imgFoto.layer.borderWidth = 2;
    imgFoto.layer.borderColor = [UIColor whiteColor].CGColor;
    imgFoto.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    lblQtdCarona.text = [NSString stringWithFormat:@"%@", participanteLogado.viajensCarona];
    lblQtdMotorista.text = [NSString stringWithFormat:@"%@", participanteLogado.viajensMotorista];
    
    lblNome.text = participanteLogado.nome;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", participanteLogado.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    
    imgFoto.image = [UIImage imageWithContentsOfFile:imageFileName];
    
    lblCarro.hidden = lblPlaca.hidden = YES;
    
    for (Veiculo *veiculo in participanteLogado.carro) {
        if (veiculo.modelo.length > 0) {
            lblCarro.text = veiculo.modelo;
            lblPlaca.text = veiculo.placa;
            lblCarro.hidden = lblPlaca.hidden = NO;
            veiculoSelecionado = veiculo;
            return;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnMotoristaClick:(id)sender {

    Participante *part = [AppHelper getParticipanteLogado];
    /*
    if ([part.viajensMotorista intValue] <= 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Você já excedeu o número de viagens como motorista !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    } */
    
    carona = NO;
    [part setMotorista:[NSNumber numberWithBool:YES]];
    [self performSegueWithIdentifier:@"sgDefinirTrajeto" sender:self];
}

- (IBAction)btnCaronaClick:(id)sender {
    Participante *part = [AppHelper getParticipanteLogado];
    /*
    if ([part.viajensCarona intValue] <= 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Você já excedeu o número de viagens como carona !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    */
    carona = YES;
    [part setMotorista:[NSNumber numberWithBool:NO]];
    [self performSegueWithIdentifier:@"sgDefinirTrajeto" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    /*
    if ([segue.identifier isEqualToString:@"sgDefinirTrajeto"]) {
        DefinirTrajetoViewController *view = (DefinirTrajetoViewController*) segue.destinationViewController;
        view.carona = carona;
        if (veiculoSelecionado) {
            view.veiculo = veiculoSelecionado;
        }
    } */
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
