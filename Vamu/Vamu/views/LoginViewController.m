//
//  LoginViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 10/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "LoginViewController.h"
#import "Participante.h"
#import "AppHelper.h"
#import "SelecionarTipoViewController.h"
#import "LoginService.h"
#import "CustomActivityView.h"
#import "CadastroParticipanteViewController.h"
#import "BaixarImagemService.h"
#import "MascaraHelper.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Participante *participanteLogado;
@property (strong, nonatomic) LoginService *loginService;
@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) BaixarImagemService *baixarImagemService;
@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;
@property (nonatomic) NSArray *formItems;
@property (strong, nonatomic) MascaraHelper *mascaraHelper;
@property (nonatomic) BOOL baixandoImagemPessoa;

@end

@implementation LoginViewController

@synthesize viewCampos;
@synthesize edtCPF;
@synthesize edtSenha;
@synthesize btnEntrar;
@synthesize participanteLogado;
@synthesize loginService;
@synthesize ampulheta, baixandoImagemPessoa;
@synthesize baixarImagemService, formItems, mascaraHelper;
@synthesize lblVersao;

//NSString *const mascaraCPF = @"000.000.000-00";


- (void)viewDidLoad
{
    [super viewDidLoad];
    [viewCampos setBackgroundColor:[UIColor colorWithRed:0.867 green:0.886 blue:0.918 alpha:1.0]];
    
    loginService = [LoginService new];
    loginService.delegate = self;
    
    baixarImagemService = [BaixarImagemService new];
    baixarImagemService.delegate = self;
    
    ampulheta = [CustomActivityView new];
    
    [edtCPF setButtonImage:[UIImage imageNamed:@"OkUp.png"]];
    
    edtSenha.delegate = self;
    edtCPF.delegate   = self;
    
    lblVersao.text = [(AppDelegate*)[[UIApplication sharedApplication] delegate] numeroVersao];
    
    self.enhancedKeyboard = [KSEnhancedKeyboard new];
    self.enhancedKeyboard.delegate = self;

    self.formItems = [NSArray arrayWithObjects:edtCPF, edtSenha, nil];
    
    mascaraHelper = [MascaraHelper new];
    baixandoImagemPessoa = YES;
    self.navigationItem.hidesBackButton = YES;
}

-(void) placeHolderTextField{
    edtCPF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtCPF.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtSenha.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtSenha.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
}

-(void) viewWillAppear:(BOOL)animated{
    edtCPF.text = @"";
    edtSenha.text = @"";
    self.navigationController.navigationBarHidden = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    NSDictionary *dadosUsuario = [AppHelper carregaUsuarioLogado];
    if (dadosUsuario) {
        edtCPF.text = [dadosUsuario objectForKey:@"cpf"];
        edtSenha.text = [dadosUsuario objectForKey:@"senha"];
        [self btnEntrarClick:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicouTela:(id)sender {
    if ([edtCPF isFirstResponder]) {
        [edtCPF resignFirstResponder];
    }
    if ([edtSenha isFirstResponder]) {
        [edtSenha resignFirstResponder];
    }
}

- (IBAction)btnEntrarClick:(id)sender {
    
    if (edtCPF.isFirstResponder) {
        [edtCPF resignFirstResponder];
    }
    
    if (edtSenha.isFirstResponder) {
        [edtSenha resignFirstResponder];
    }
    
    if ([edtCPF.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Informe o CPF" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    if ([edtSenha.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Informe a senha" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    [ampulheta exibir];
    [loginService fazerLoginComCPF:edtCPF.text eSenha:edtSenha.text];

}

- (IBAction)btnCadastreseClick:(id)sender {
    [self performSegueWithIdentifier:@"sgCadastroParticipante" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [edtCPF resignFirstResponder];
    [edtSenha resignFirstResponder];
    if ([segue.identifier isEqualToString:@"sgCadastroParticipante"]) {
        CadastroParticipanteViewController *view = segue.destinationViewController;
        [view setCpf:edtCPF.text];
        [view setSenha:edtSenha.text];
        return;
    }
    if ([segue.identifier isEqualToString:@"sgCadastrarVeiculo"]) {
        CadastroVeiculoViewController *view = segue.destinationViewController;
        view.proprietario = [AppHelper getParticipanteLogado];
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
                [ampulheta exibir];
                NSString *cpfLimpo = [AppHelper limparCPF:edtCPF.text];
                [loginService derrubarSessao:cpfLimpo];
            }
            break;
            
        default:
            break;
    }
    
    if (alertView.tag == 0) {
        
    }
}

#pragma mark - LoginServiceDelegate

-(void)loginCaronComViagem{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"CPF informado está em viagem. Favor verificar" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles: nil]show];
}

-(void)loginCaronSemViagem{
    [self loginMotoristaSemViagem];
}

-(void)loginContaNaoAtiva: (Participante*) participante{
    [ampulheta esconder];
    [AppHelper setParticipanteLogado:participante];
    [AppHelper salvarUsuario:participante.cpf senha:edtSenha.text];
    [self performSegueWithIdentifier:@"sgCadastrarVeiculo" sender:self];
}

-(void)loginCPFNaoCadastrado{
    [ampulheta esconder];
    UIAlertView *alertCadastro = [[UIAlertView alloc] initWithTitle:@"Login" message:@"CPF não cadastrado. Deseja cadastrar?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Sim", nil];
    
    alertCadastro.tag = 0;
    [alertCadastro show];
}

-(void)loginErro:(NSString *)erro{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Login" message:erro delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)loginErroSenhaTerceiraTentativa{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Você erro a senha pela terceira vez. Sua conta ficará bloqueada por 15 minutos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)loginFalhaAoSalvarAcesso{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Erro ao registrar o acesso." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)loginMotoristaComViagem{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"CPF informado está em viagem. Favor verificar" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles: nil]show];
}

-(void)loginMotoristaSemViagem{
    [ampulheta esconder];
    
    UIAlertView *alertSessao = [[UIAlertView alloc] initWithTitle:@"Login" message:@"CPF ativo em outra sessão. Deseja prosseguir o login?" delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles:@"Prosseguir", nil];
    
    alertSessao.tag = 1;
    
    [alertSessao show];
}

-(void)loginComAtivoEmOutroAparelho {
    [ampulheta esconder];
    
    UIAlertView *alertSessao = [[UIAlertView alloc] initWithTitle:@"Login" message:@"CPF ativo em outro aparelho!" delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles: nil];
    [alertSessao show];
}

-(void)loginOk:(Participante *)participante{
    //A ampulheta será escondida após o download do participante
//    [ampulheta esconder];
    [AppHelper setParticipanteLogado:participante];
    [AppHelper salvarUsuario:participante.cpf senha:edtSenha.text];
    [baixarImagemService baixarImagemDePessoa:participante.cpf];
}

-(void)loginSenhaInvalida{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Login" message:@"Senha inválida." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)onOcorreuTimeout:(NSString *)msg{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Login" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
//    if (textField == edtSenha) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 100.0), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
//    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField == edtSenha) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 100.0), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
//    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [edtSenha resignFirstResponder];
    [edtCPF resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == edtCPF) {
        return [mascaraHelper mascarar:textField shouldChangeCharactersInRange:range replacementString:string mascara:MascaraHelper.MASCARA_CPF];
    }
    return YES;
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
        [ampulheta esconder];
        [self performSegueWithIdentifier:@"sgDefinirTipo" sender:self];
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
