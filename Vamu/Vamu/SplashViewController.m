//
//  SplashViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 16/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "SplashViewController.h"
#import "BaixarImagemService.h"
#import "Veiculo.h"

@interface SplashViewController ()

@property (strong, nonatomic) NSString *senha;
@property (strong, nonatomic) NSString *cpf;
@property (strong, nonatomic) BaixarImagemService *baixarImagemService;
@property (nonatomic) BOOL baixandoImagemPessoa;

@end

@implementation SplashViewController

@synthesize loginService, senha, cpf, baixarImagemService, baixandoImagemPessoa;

-(void)viewDidAppear:(BOOL)animated{
    sleep(2);
    
    NSDictionary *dadosUsuario = [AppHelper carregaUsuarioLogado];
    if (dadosUsuario) {
        cpf = [dadosUsuario objectForKey:@"cpf"];
        senha = [dadosUsuario objectForKey:@"senha"];
        [loginService fazerLoginComCPF:cpf eSenha:senha];
    } else {
        [self performSegueWithIdentifier:@"sgLogin" sender:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loginService = [LoginService new];
    loginService.delegate = self;
    
    baixarImagemService = [BaixarImagemService new];
    baixarImagemService.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
    
    baixandoImagemPessoa = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - LoginServiceDelegate

-(void)loginCaronComViagem{
    [self loginMotoristaSemViagem];
}

-(void)loginCaronSemViagem{
    [self loginMotoristaSemViagem];
}

-(void)loginContaNaoAtiva:(Participante*) participante{
    [AppHelper setParticipanteLogado:participante];
    [AppHelper salvarUsuario:participante.cpf senha:senha];
    [self performSegueWithIdentifier:@"sgSplashCadastroVeiculo" sender:self];
}

-(void)loginCPFNaoCadastrado{
    UIAlertView *alertCadastro = [[UIAlertView alloc] initWithTitle:@"Login" message:@"CPF não cadastrado. Deseja cadastrar?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Sim", nil];
    
    alertCadastro.tag = 0;
    [alertCadastro show];
}

-(void)loginErro:(NSString *)erro{
    [[[UIAlertView alloc] initWithTitle:@"Login" message:erro delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)loginErroSenhaTerceiraTentativa{
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Você erro a senha pela terceira vez. Sua conta ficará bloqueada por 15 minutos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)loginFalhaAoSalvarAcesso{
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Erro ao registrar o acesso." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)loginMotoristaComViagem{
    [self loginMotoristaSemViagem];
}

-(void)loginMotoristaSemViagem{
    
    UIAlertView *alertSessao = [[UIAlertView alloc] initWithTitle:@"Login" message:@"CPF ativo em outra sessão. Deseja prosseguir o login?" delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim", nil];
    
    alertSessao.tag = 1;
    
    [alertSessao show];
}

-(void)loginOk:(Participante *)participante{
    [AppHelper setParticipanteLogado:participante];
    [AppHelper salvarUsuario:participante.cpf senha:senha];
    [baixarImagemService baixarImagemDePessoa:participante.cpf];
}

-(void)loginSenhaInvalida{
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Senha inválida." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)onOcorreuTimeout:(NSString *)msg{
    [[[UIAlertView alloc] initWithTitle:@"Login" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - AlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 0:
            if (buttonIndex == 1) {
                [self performSegueWithIdentifier:@"sgCadastroParticipante" sender:self];
            }
            break;
            
        case 1:
            if (buttonIndex == 1) {
                NSString *cpfLimpo = [AppHelper limparCPF:cpf];
                [loginService derrubarSessao:cpfLimpo];
            }
            break;
            
        default:
            break;
    }
    
    if (alertView.tag == 0) {
        
    }
}

-(void) finalizaBaixarImagem {
    if (baixandoImagemPessoa) {
        baixandoImagemPessoa = NO;
        Participante *participante = [AppHelper getParticipanteLogado];
        NSSet *carros = participante.carro;
        for (Veiculo *carro in carros) {
            [baixarImagemService baixarImagemDeCarro:participante.cpf placa:carro.placa];
            break;
        }
    } else {
        [self performSegueWithIdentifier:@"sgSplashDefinirTipo" sender:self];
    }
}

@end
