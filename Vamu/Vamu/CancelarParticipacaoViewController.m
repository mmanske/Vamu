//
//  CancelarParticipacaoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 20/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CancelarParticipacaoViewController.h"
#import "AppHelper.h"
#import "CustomActivityView.h"
#import "SolicitarAdesaoCell.h"
#import "GrupoService.h"

@interface CancelarParticipacaoViewController ()

@property (nonatomic, strong) ConsultaGrupoService *consultaGrupoService;
@property (strong, nonatomic) NSMutableArray *gruposRetorno;
@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (nonatomic, strong) GrupoService *grupoService;

@end

@implementation CancelarParticipacaoViewController

@synthesize ampulheta;
@synthesize gruposRetorno;
@synthesize tabela;
@synthesize consultaGrupoService;
@synthesize grupoService;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tabela.delegate = self;
    tabela.dataSource = self;
    
    gruposRetorno = [NSMutableArray new];
    
    consultaGrupoService = [ConsultaGrupoService new];
    consultaGrupoService.delegate = self;
    
    grupoService = [GrupoService new];
    grupoService.delegate = self;
    
    ampulheta = [CustomActivityView new];
    [ampulheta exibir];
    
    [consultaGrupoService consultarGruposParticipante:[AppHelper getParticipanteLogado].codParticipante];
    
    [tabela reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [tabela reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [gruposRetorno count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *adesaoCell = @"SolicitarAdesaoCell";
    
    SolicitarAdesaoCell *cell = (SolicitarAdesaoCell *)[tabela dequeueReusableCellWithIdentifier:adesaoCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:adesaoCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Grupo *grupo = [gruposRetorno objectAtIndex:indexPath.row];
    
    cell.lblNomeGrupo.text = grupo.nome;
    cell.swtSolicitar.on = NO;
    cell.grupo = grupo;
    cell.delegate = self;
        
    return cell;
}

#pragma mark - GrupoCellDelegate

-(void) onSolicitouParticipacao:(Grupo *)grupo index:(int)index valor:(BOOL)valor{
    if (valor) {
        [ampulheta exibir];
        [grupoService cancelarParticipacao:grupo status:@"4"];
    }
}

#pragma mark - GrupoServiceDelegate

-(void)grupoCancelamentoEfetuado{
    [consultaGrupoService consultarGruposParticipante:[AppHelper getParticipanteLogado].codParticipante];
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cancelar Participação" message:@"Cancelamento de participação efetuado" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

-(void)grupoEnviaMensagemErro:(NSString *)mensagem{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cancelar Participação" message:mensagem delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - ConsultaGrupoServiceDelegate

-(void)grupoConsultaRetorno:(NSMutableArray *)grupos{
    [ampulheta esconder];
    gruposRetorno = grupos;
    [tabela reloadData];

}

-(void)grupoConsultaEnviaMensagemErro:(NSString *)mensagem{
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cancelar participação" message:@"Erro ao consultar grupos" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

@end
