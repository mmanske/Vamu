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

@interface ResumoMotoristaViewController ()

@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) NSMutableArray *caronas;
@property (strong, nonatomic) ResumoViagemService *resumoService;

@end

@implementation ResumoMotoristaViewController

@synthesize tabela, caronas, lblOrigem, lblNomeParticipante, lblDestino, lblDesconsumoParticipante, lblEmissaoParticipante, lblDesconsumoViagem, lblEmissaoViagem, lblDesconsumoVamu, lblEmissaoVamu, imgParticipante, ampulheta, resumoService;

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
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 1;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    [ampulheta exibir];
    
    resumoService = [ResumoViagemService new];
    resumoService.delegate = self;
    
    [resumoService resumoViagemMotorista];
    
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
    
    lblNomeParticipante.text = [AppHelper getParticipanteLogado].nome;
    
    lblDestino.text = [AppHelper getNomeDestino];
    lblOrigem.text = [AppHelper getNomeOrigem];
    
    lblEmissaoViagem.text = [NSString stringWithFormat:@"Você 'desconsumiu' %.2f km nessa viagem", [[dicResumo objectForKey:@"co2Viagem"] floatValue]];
    
    lblDesconsumoViagem.text = [NSString stringWithFormat:@"e deixou de emitir %.2f ton. de CO2", [[dicResumo objectForKey:@"kmViagem"] floatValue]];
    
    lblEmissaoParticipante.text = [NSString stringWithFormat:@"Você deixou de emitir: %.2f ton. de CO2", [[dicResumo objectForKey:@"co2Usuario"] floatValue]];
    
    lblDesconsumoParticipante.text = [NSString stringWithFormat:@"Seu 'desconsumo' total: %.2f km", [[dicResumo objectForKey:@"kmUsuario"] floatValue]];
    
    lblEmissaoVamu.text = [NSString stringWithFormat:@"Deixamos de emitir: %.2f ton. de CO2", [[dicResumo objectForKey:@"co2Vamu"] floatValue]];
    
    lblDesconsumoVamu.text = [NSString stringWithFormat:@"'Desconsumo' TOTAL do Vamu: %.2f km", [[dicResumo objectForKey:@"kmVamu"] floatValue]];
    
}

@end
