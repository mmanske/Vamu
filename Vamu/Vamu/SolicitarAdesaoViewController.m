//
//  SolicitarAdesaoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 05/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "SolicitarAdesaoViewController.h"
#import "SolicitarAdesaoCell.h"
#import "Grupo.h"
#import "GrupoService.h"
#import "CustomActivityView.h"
#import "AppHelper.h"

@interface SolicitarAdesaoViewController ()

@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) NSMutableArray *retorno;
@property (strong, nonatomic) GrupoService *grupoService;

@end

@implementation SolicitarAdesaoViewController

@synthesize retorno;
@synthesize tabela;
@synthesize edtNomeGrupo;
@synthesize grupoService;
@synthesize ampulheta;

- (void)viewDidLoad
{
    [super viewDidLoad];
    retorno = [NSMutableArray new];
    
    ampulheta = [CustomActivityView new];
    
    tabela.delegate = self;
    tabela.dataSource = self;
    
    grupoService = [GrupoService new];
    grupoService.delegate = self;
    
    self.exibirNavigationBar = YES;
    
    edtNomeGrupo.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableViewDelegate/DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *adesaoCell = @"SolicitarAdesaoCell";
    
    SolicitarAdesaoCell *cell = (SolicitarAdesaoCell *)[tabela dequeueReusableCellWithIdentifier:adesaoCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:adesaoCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Grupo *grupo = [retorno objectAtIndex:indexPath.row];
    
    cell.lblNomeGrupo.text = grupo.nome;
    cell.swtSolicitar.on = NO;
    cell.grupo = grupo;
    cell.delegate = self;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [retorno count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (edtNomeGrupo.text.length > 1) {
        [grupoService consultarGrupoPorNome:edtNomeGrupo.text];
    }
    return YES;
}

#pragma mark - GrupoServiceDelegate

-(void)grupoConsultaNomeRetorno:(NSMutableArray *)grupos{
    [retorno removeAllObjects];
    [retorno addObjectsFromArray:grupos];
    [tabela reloadData];
}

-(void)grupoSolicitacaoEnviada{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Solicitação de adesão" message:@"Solicitação de participação enviada" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    retorno = nil;
    edtNomeGrupo.text = @"";
}

-(void)grupoEnviaMensagemErro:(NSString *)mensagem{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Solicitação de adesão" message:mensagem delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SolicitarAdesaoCellDelegate

-(void)onSolicitouParticipacao:(Grupo *)grupo index:(int)index valor:(BOOL)valor{
    [edtNomeGrupo resignFirstResponder];
    if ([grupo.receberSolicitacao isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [ampulheta exibir];
        [grupoService solicitarAdesao:grupo participanteSolicitante:[AppHelper getParticipanteLogado]];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Grupo" message:@"Grupo não aceita solicitação de adesão" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles: nil] show];
    }
}

@end
