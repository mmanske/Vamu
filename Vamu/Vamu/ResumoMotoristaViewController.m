//
//  ResumoMotoristaViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 15/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ResumoMotoristaViewController.h"
#import "CustomActivityView.h"
#import "ResumoViagemService.h"
#import "AppHelper.h"
#import "ParticipanteResumoVO.h"
#import "BaixarImagemService.h"
#import "Veiculo.h"

@interface ResumoMotoristaViewController ()

@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) NSMutableArray *caronas;
@property (strong, nonatomic) ResumoViagemService *resumoService;
@property (strong, nonatomic) BaixarImagemService *imagemService;
@property (nonatomic) BOOL podeAtualizarTabela;
@property int quantFoto;

@end

@implementation ResumoMotoristaViewController

@synthesize tabela, caronas, lblOrigem, lblNomeParticipante, lblDestino, lblDesconsumoParticipante, lblEmissaoParticipante, lblDesconsumoViagem, lblEmissaoViagem, lblDesconsumoVamu, lblEmissaoVamu, imgParticipante, ampulheta, resumoService, imagemService, podeAtualizarTabela, quantFoto, lblCarro, lblPlaca;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ampulheta exibir];
    
    podeAtualizarTabela = NO;
    
    quantFoto = 0;
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 1;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    caronas = [NSMutableArray new];
    
    resumoService = [ResumoViagemService new];
    resumoService.delegate = self;
    [resumoService resumoViagemMotorista];
    
    imagemService = [BaixarImagemService new];
    imagemService.delegate = self;
    
    tabela.dataSource = self;
    tabela.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *resumoCell = @"ResumoCell";
    
    ResumoCell *cell = (ResumoCell *)[tabela dequeueReusableCellWithIdentifier:resumoCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:resumoCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    ParticipanteResumoVO *part = [caronas objectAtIndex:indexPath.row];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [AppHelper getParticipanteLogado].cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    
    cell.imgCarona.image = [UIImage imageWithContentsOfFile:imageFileName];
    cell.lblNomeCarona.text = part.nome;
    cell.lblHoraViagem.text = [NSString stringWithFormat:@"%@ / %@", part.horaInicio, part.horaFim];
    cell.lblDistanciaPercorrida.text = [NSString stringWithFormat:@"%@Km", part.kmViagem];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [caronas count];
}

#pragma mark - ResumoViagemServiceDelegate

-(void)onRetornouResumo:(NSDictionary *)dicResumo{
    [ampulheta esconder];
    
    NSDictionary *dicCaronas = [dicResumo objectForKey:@"resumoCaronas"];
    
    for (NSDictionary *dicCarona in dicCaronas) {
        ParticipanteResumoVO *part = [ParticipanteResumoVO new];
        
        NSString *cpf = [dicCarona objectForKey:@"cpf"];
        NSString *nome = [dicCarona objectForKey:@"nomeUsuario"];
        NSString *horaInicio = [dicCarona objectForKey:@"horaInicio"];
        NSString *horaFim = [dicCarona objectForKey:@"horaFim"];
        NSString *km = [NSString stringWithFormat:@"%@",[dicCarona objectForKey:@"kmViagem"]];
        
        part.nome = nome;
        part.cpf = cpf;
        part.horaInicio = horaInicio;
        part.horaFim = horaFim;
        part.kmViagem = km;
        
        [imagemService baixarImagemDePessoa:part.cpf];
        
        [caronas addObject:part];
    }
    
    NSDictionary *veiculos = [dicResumo objectForKey:@"veiculoVO"];
    
    lblCarro.text = [NSString stringWithFormat:@"%@", [veiculos objectForKey:@"modelo"]];
    lblPlaca.text = [NSString stringWithFormat:@"Placa %@", [veiculos objectForKey:@"placa"]];
    
    lblNomeParticipante.text = [AppHelper getParticipanteLogado].nome;
    
    lblDestino.text = [AppHelper getNomeDestino];
    lblOrigem.text = [AppHelper getNomeOrigem];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [AppHelper getParticipanteLogado].cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    
    imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];
    
    lblEmissaoViagem.text = [NSString stringWithFormat:@"Você 'desconsumiu' %.2f km nessa viagem", [[dicResumo objectForKey:@"co2Viagem"] floatValue]];
    
    lblDesconsumoViagem.text = [NSString stringWithFormat:@"e deixou de emitir %.2f ton. de CO2", [[dicResumo objectForKey:@"kmViagem"] floatValue]];
    
    lblEmissaoParticipante.text = [NSString stringWithFormat:@"Você deixou de emitir: %.2f ton. de CO2", [[dicResumo objectForKey:@"co2Usuario"] floatValue]];
    
    lblDesconsumoParticipante.text = [NSString stringWithFormat:@"Seu 'desconsumo' total: %.2f km", [[dicResumo objectForKey:@"kmUsuario"] floatValue]];
    
    lblEmissaoVamu.text = [NSString stringWithFormat:@"Deixamos de emitir: %.2f ton. de CO2", [[dicResumo objectForKey:@"co2Vamu"] floatValue]];
    
    lblDesconsumoVamu.text = [NSString stringWithFormat:@"'Desconsumo' TOTAL do Vamu: %.2f km", [[dicResumo objectForKey:@"kmVamu"] floatValue]];
    
    for (Veiculo *veiculo in [AppHelper getParticipanteLogado].carro) {
        lblCarro.text = [NSString stringWithFormat:@"%@ - %@", veiculo.modelo, veiculo.cor];
        lblPlaca.text = [NSString stringWithFormat:@"Placa %@", veiculo.placa];
        return;
    }
    
}

#pragma mark - BaixarImagemServiceDelegate

-(void)finalizaBaixarImagem{
    quantFoto++;
    if (quantFoto == [caronas count]) {
        [tabela reloadData];
    }
}

@end
