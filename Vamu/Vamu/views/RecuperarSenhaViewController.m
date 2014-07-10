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

@interface RecuperarSenhaViewController ()

@property (nonatomic, strong) RecuperarSenhaService *recuperarSenhaService;
@property (nonatomic, strong) CustomActivityView *ampulheta;

@end

@implementation RecuperarSenhaViewController

@synthesize ampulheta;
@synthesize edtEmail;
@synthesize btnEnviar;
@synthesize scrollView;
@synthesize recuperarSenhaService;

- (void)viewDidLoad
{
    [super viewDidLoad];
    edtEmail.delegate = self;
    scrollView.contentSize=CGSizeMake(320,480);
    self.exibirNavigationBar = YES;
    recuperarSenhaService = [RecuperarSenhaService new];
    recuperarSenhaService.delegate = self;
    
    ampulheta = [CustomActivityView new];
    
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

#pragma mark - RecuperarSenhaServiceDelegate

-(void)recuperarSenhaOk{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Recuperação de senha" message:@"Sua senha foi enviada para o seu e-mail" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)recuperarSenhaFalhaAoEnviar{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Recuperação de senha" message:@"Erro ao recuperar senha" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)recuperarSenhaCPFNaoCadastrado{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Recuperação de senha" message:@"CPF informado não cadastrado no VAMU" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
