//
//  ReceberAvisoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 19/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ReceberAvisoViewController.h"
#import "SolicitarAdesaoCell.h"
#import "GrupoService.h"
#import "CustomActivityView.h"

@interface ReceberAvisoViewController ()

@property (strong, nonatomic) NSMutableArray *grupos;
@property (strong, nonatomic) GrupoService *grupoService;
@property (strong, nonatomic) CustomActivityView *ampulheta;

@end

@implementation ReceberAvisoViewController

@synthesize tabela, grupos = _grupos, grupoService, ampulheta;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ampulheta = [CustomActivityView new];
    
    grupoService = [GrupoService new];
    grupoService.delegate = self;
    
    self.title = @"Aviso Motorista";
}

-(void)viewDidAppear:(BOOL)animated{
    [ampulheta exibir];
    [grupoService consultarGruposParticipante];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_grupos count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *adesaoCell = @"SolicitarAdesaoCell";
    
    SolicitarAdesaoCell *cell = (SolicitarAdesaoCell *)[tabela dequeueReusableCellWithIdentifier:adesaoCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:adesaoCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Grupo *grupo = [_grupos objectAtIndex:indexPath.row];
    
    cell.lblNomeGrupo.text = grupo.nome;
    cell.swtSolicitar.on = NO;
    cell.grupo = grupo;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - GrupoServiceDelegate

-(void)grupoConsultaNomeRetorno:(NSMutableArray *)grupos{
    [ampulheta esconder];
    _grupos = grupos;
    [tabela reloadData];
}

-(void)onSolicitouParticipacao:(Grupo *)grupo{
    
}

@end
