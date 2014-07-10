//
//  MenuViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 12/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "MenuViewController.h"
#import "MapaGoogleViewController.h"

#import "LoginViewController.h"
#import "RecuperarSenhaViewController.h"
#import "CadastroParticipanteViewController.h"
#import "CadastroVeiculoViewController.h"
#import "AppHelper.h"

@interface MenuViewController ()

@property (strong, nonatomic) UIWindow *window;

@end

@implementation MenuViewController

@synthesize delegate, rota;
@synthesize lblNomeParticipante, imgParticipante;
@synthesize participanteLogado;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.exibirNavigationBar = YES;
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 2;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    lblNomeParticipante.text = participanteLogado.nome;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", participanteLogado.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];
    
//    [self montarView];
}

-(void)montarView{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)meusDados:(id)sender {

}

- (IBAction)alterarSenha:(id)sender {
    
}

- (IBAction)editarVeiculo:(id)sender {
//    CadastroVeiculoViewController *view = [[CadastroVeiculoViewController alloc] init];
//    [self trocarView:view];
}

- (IBAction)editarGrupo:(id)sender {
}

- (IBAction)solicitarAdesao:(id)sender {
}

- (IBAction)cancelarParticipacao:(id)sender {
}

- (IBAction)aceitarParticipacao:(id)sender {
}

- (IBAction)enviarConvite:(id)sender {
}

- (IBAction)receberAviso:(id)sender {
}

- (IBAction)minhasViagens:(id)sender {
}

- (IBAction)sair:(id)sender {
//    LoginViewController *view = [[LoginViewController alloc] init];
//    [self trocarView:view];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
