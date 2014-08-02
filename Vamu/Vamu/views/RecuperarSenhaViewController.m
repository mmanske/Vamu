//
//  RecuperarSenhaViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 10/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "RecuperarSenhaViewController.h"
#import "CSNotificationView.h"
#import "CustomActivityView.h"
#import "MascaraHelper.h"
#import "Validations.h"
#import "AppHelper.h"
#import "CadastroParticipanteViewController.h"

@interface RecuperarSenhaViewController ()

@property (nonatomic, strong) RecuperarSenhaService *recuperarSenhaService;
@property (nonatomic, strong) CustomActivityView *ampulheta;
@property (strong, nonatomic) MascaraHelper *mascaraHelper;
@end

@implementation RecuperarSenhaViewController

@synthesize ampulheta;
@synthesize edtEmail;
@synthesize btnEnviar;
@synthesize scrollView;
@synthesize recuperarSenhaService, mascaraHelper;

- (void)viewDidLoad
{
    [super viewDidLoad];
    edtEmail.delegate = self;
    scrollView.contentSize=CGSizeMake(320,480);
    self.exibirNavigationBar = YES;
    recuperarSenhaService = [RecuperarSenhaService new];
    recuperarSenhaService.delegate = self;
    
    ampulheta = [CustomActivityView new];
    mascaraHelper = [MascaraHelper new];

    [[SDCAlertView appearance] setButtonTextColor:[UIColor greenColor]];
    [[SDCAlertView appearance] setMessageLabelTextColor:[UIColor blackColor]];
}

-(void) viewDidAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clicouTela:(id)sender {
    if ([edtEmail isFirstResponder]) {
        [edtEmail resignFirstResponder];
    }
    CGPoint ponto = CGPointMake(0, -64);
    [scrollView setContentOffset:ponto animated:YES];
}

- (IBAction)btnEnviarClick:(id)sender {
    
    
    if (edtEmail.text.length <= 0) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Informe o CPF"];
        return;
    }
    
    if ([edtEmail isFirstResponder]) {
        [edtEmail resignFirstResponder];
        CGPoint ponto = CGPointMake(0, 0);
        [scrollView setContentOffset:ponto animated:YES];
    }

    if (![Validations validateCPFWithNSString: [AppHelper limparCPF:edtEmail.text]]) {
        [[[SDCAlertView alloc] initWithTitle:nil message:@"CPF inválido." delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles: nil] show];
        return;

    }
    
    
    [ampulheta exibir];
    [recuperarSenhaService recuperarSenha:edtEmail.text];
}

- (IBAction)clicouEdit:(id)sender {
    CGPoint ponto = CGPointMake(0, 120);
    [scrollView setContentOffset:ponto animated:YES];
}


#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    CGPoint ponto = CGPointMake(0, 0);
    [scrollView setContentOffset:ponto animated:YES];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == edtEmail) {
        return [mascaraHelper mascarar:textField shouldChangeCharactersInRange:range replacementString:string mascara:MascaraHelper.MASCARA_CPF];
    }
    return YES;
}


#pragma mark - RecuperarSenhaServiceDelegate

-(void)recuperarSenhaOk{
    [ampulheta esconder];
    [[[SDCAlertView alloc] initWithTitle:nil message:@"Senha enviada com sucesso." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)recuperarSenhaFalhaAoEnviar{
    [ampulheta esconder];
    [[[SDCAlertView alloc] initWithTitle:@"Recuperação de senha" message:@"Erro ao recuperar senha." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)recuperarSenhaCPFNaoCadastrado{
    
    [ampulheta esconder];
    
    
    [[[SDCAlertView alloc] initWithTitle:@"Participante não cadastrado" message:@"Deseja se cadastrar ?" delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles: @"Cadastrar", nil] show];
}
-(void)alertView:(SDCAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"sgCadastroParticipanteRecSenha" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [edtEmail resignFirstResponder];
    CadastroParticipanteViewController *view = segue.destinationViewController;
    [view setCpf:edtEmail.text];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
