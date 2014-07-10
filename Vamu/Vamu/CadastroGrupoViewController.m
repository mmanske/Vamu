//
//  CadastroGrupoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 05/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CadastroGrupoViewController.h"
#import "CSNotificationView.h"
#import "GrupoService.h"
#import "CustomActivityView.h"
#import "AppHelper.h"

@interface CadastroGrupoViewController ()

@property (strong, nonatomic) Participante *participante;
@property (strong, nonatomic) GrupoService *grupoService;
@property (strong, nonatomic) CustomActivityView *ampulheta;

@end

@implementation CadastroGrupoViewController

@synthesize participante;
@synthesize edtDescricao;
@synthesize edtNome;
@synthesize swtAtivarFiltros;
@synthesize swtGrupoVisivel;
@synthesize swtReceberSolicitacao;
@synthesize grupoService;
@synthesize ampulheta;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.exibirNavigationBar = YES;
    
    grupoService = [GrupoService new];
    grupoService.delegate = self;
    
    ampulheta = [CustomActivityView new];
    
    edtNome.delegate = edtDescricao.delegate = self;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancelarClick:(id)sender {

}

- (IBAction)btnSalvarClick:(id)sender {
    [ampulheta exibir];
    if ([self validouDados]) {
        Grupo *grupo = [Grupo new];
        grupo.nome = edtNome.text;
        grupo.descricao = edtDescricao.text;
        grupo.visivel = [NSNumber numberWithBool:swtGrupoVisivel.on];
        grupo.receberSolicitacao = [NSNumber numberWithBool:swtReceberSolicitacao.on];
        grupo.ativarFiltros = [NSNumber numberWithBool:swtAtivarFiltros.on];
        grupo.moderador = [AppHelper getParticipanteLogado];
        
        [grupoService cadastrarGrupo:grupo];
    }
}

- (IBAction)clicouTela:(id)sender {
    if ([edtDescricao isFirstResponder]) {
        [edtDescricao resignFirstResponder];
    }
    
    if ([edtNome isFirstResponder]) {
        [edtNome resignFirstResponder];
    }
}

-(BOOL) validouDados{
    if (edtNome.text.length <= 0) {
        [ampulheta esconder];
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Informe o nome do grupo"];
        return NO;
    }
    
    if (edtDescricao.text.length <= 0) {
        [ampulheta esconder];
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Informe a descrição"];
        return NO;
    }
    
    return YES;
}

-(void) limparDados{
    edtDescricao.text = @"";
    edtNome.text = @"";
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - GrupoServiceDelegate

-(void)grupoCadastradoComSucesso{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cadastro de grupo" message:@"Grupo cadastrado com sucesso" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    [self limparDados];
}

-(void)grupoEnviaMensagemErro:(NSString *)mensagem{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cadastro de grupo" message:mensagem delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)grupoNaoValidouNome:(NSString *)mensagem{
    [ampulheta esconder];
}

@end
