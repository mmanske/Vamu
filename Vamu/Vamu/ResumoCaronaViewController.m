//
//  ResumoCaronaViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 15/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ResumoCaronaViewController.h"
#import "ResumoViagemService.h"
#import "CustomActivityView.h"
#import "AppHelper.h"
#import "Veiculo.h"
#import "BaixarImagemService.h"

@interface ResumoCaronaViewController ()

@property (strong, nonatomic) ResumoViagemService *resumoService;
@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) BaixarImagemService *imagemService;
@property (strong, nonatomic) NSMutableString *cpfMotorista;

@end

@implementation ResumoCaronaViewController

@synthesize lblCarro, lblDataViagem, lblDesconsumoParticipante, lblDesconsumoVamu ,lblDesconsumoViagem, lblDestino, lblEmissaoParticipante, lblEmissaoVamu, lblEmissaoViagem, lblNomeMotorista, lblNomeParticipante, lblOrigem, lblPlaca, lblResumoViagem, imgMotorista, imgParticipante, ampulheta, resumoService, imagemService, cpfMotorista, dicionarioResumo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 1;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    imgMotorista.layer.cornerRadius = imgMotorista.bounds.size.width/2;
    imgMotorista.layer.masksToBounds = YES;
    imgMotorista.layer.borderWidth = 1;
    imgMotorista.layer.borderColor = [UIColor whiteColor].CGColor;
    imgMotorista.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    [ampulheta exibir];
    
    if (dicionarioResumo) {
        [self exibirDados:dicionarioResumo];
    }
    
//    resumoService = [ResumoViagemService new];
//    resumoService.delegate = self;
//    [resumoService resumoViagemCarona];
    
    imagemService = [BaixarImagemService new];
    imagemService.delegate = self;
    
    cpfMotorista = [NSMutableString new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ResumoViagemServiceDelegate

-(void) exibirDados:(NSDictionary*) dicResumo{
    NSDictionary *veiculos = [dicResumo objectForKey:@"veiculoVO"];
    
    NSLog(@"%@", dicResumo);
    
    lblCarro.text = [NSString stringWithFormat:@"%@", [veiculos objectForKey:@"modelo"]];
    lblPlaca.text = [NSString stringWithFormat:@"Placa %@", [veiculos objectForKey:@"placa"]];
    
    cpfMotorista = [dicResumo objectForKey:@"cpf"];
    
    [imagemService baixarImagemDePessoa:cpfMotorista];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [AppHelper getParticipanteLogado].cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    
    imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];
    
    lblNomeParticipante.text = [AppHelper getParticipanteLogado].nome;
    
    lblResumoViagem.text = [NSString stringWithFormat:@"Resumo da viagem %@", [AppHelper getParticipanteLogado].codViagemAtual];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString* data = [dateFormatter stringFromDate:[NSDate date]];
    
    lblDataViagem.text = [NSString stringWithFormat:@"%@ - %@ / %@", data, [dicResumo objectForKey:@"horaInicio"], [dicResumo objectForKey:@"horaFim"]];
    
    lblDestino.text = [AppHelper getNomeDestino];
    lblOrigem.text = [AppHelper getNomeOrigem];
    
    lblNomeMotorista.text = [dicResumo objectForKey:@"nomeUsuario"];
    
    lblEmissaoViagem.text = [NSString stringWithFormat:@"e deixou de emitir %@ ton. de CO2", [dicResumo objectForKey:@"co2Viagem"]];
    
    lblDesconsumoViagem.text = [NSString stringWithFormat:@"Você 'desconsumiu' %@ km nessa viagem", [dicResumo objectForKey:@"kmViagem"]];
    
    lblEmissaoParticipante.text = [NSString stringWithFormat:@"Você deixou de emitir: %@ ton. de CO2", [dicResumo objectForKey:@"co2Usuario"]];
    
    lblDesconsumoParticipante.text = [NSString stringWithFormat:@"Seu 'desconsumo' total: %@ km", [dicResumo objectForKey:@"kmUsuario"]];
    
    lblEmissaoVamu.text = [NSString stringWithFormat:@"Deixamos de emitir: %@ ton. de CO2", [dicResumo objectForKey:@"co2Vamu"]];
    
    lblDesconsumoVamu.text = [NSString stringWithFormat:@"'Desconsumo' TOTAL do Vamu: %@ km", [dicResumo objectForKey:@"kmVamu"]];
    
    [ampulheta esconder];
}

#pragma mark - BaixarImagemServiceDelegate

-(void)finalizaBaixarImagem{
    [ampulheta esconder];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", cpfMotorista];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    
    imgMotorista.image = [UIImage imageWithContentsOfFile:imageFileName];
}

@end
