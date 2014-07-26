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

@interface ResumoCaronaViewController ()

@property (strong, nonatomic) ResumoViagemService *resumoService;
@property (strong, nonatomic) CustomActivityView *ampulheta;

@end

@implementation ResumoCaronaViewController

@synthesize lblCarro, lblDataViagem, lblDesconsumoParticipante, lblDesconsumoVamu ,lblDesconsumoViagem, lblDestino, lblEmissaoParticipante, lblEmissaoVamu, lblEmissaoViagem, lblNomeMotorista, lblNomeParticipante, lblOrigem, lblPlaca, lblResumoViagem, imgMotorista, imgParticipante, ampulheta, resumoService;

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
    
    resumoService = [ResumoViagemService new];
    resumoService.delegate = self;
    
    [resumoService resumoViagemCarona];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - ResumoViagemServiceDelegate

-(void)onRetornouResumo:(NSDictionary *)dicResumo{
    [ampulheta esconder];
    
    lblNomeParticipante.text = [AppHelper getParticipanteLogado].nome;
    
    lblResumoViagem.text = [NSString stringWithFormat:@"Resumo da viagem %@", [AppHelper getParticipanteLogado].codViagemAtual];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString* data = [dateFormatter stringFromDate:[NSDate date]];
    
    lblDataViagem.text = [NSString stringWithFormat:@"%@ - %@ / %@", data, [dicResumo objectForKey:@"horaInicio"], [dicResumo objectForKey:@"horaFim"]];
    
    lblDestino.text = [AppHelper getNomeDestino];
    lblOrigem.text = [AppHelper getNomeOrigem];
    
    lblNomeMotorista.text = [dicResumo objectForKey:@"nomeUsuario"];
    
    lblEmissaoViagem.text = [NSString stringWithFormat:@"Você 'desconsumiu' %.2f km nessa viagem", [[dicResumo objectForKey:@"co2Viagem"] floatValue]];
    
    lblDesconsumoViagem.text = [NSString stringWithFormat:@"e deixou de emitir %.2f ton. de CO2", [[dicResumo objectForKey:@"kmViagem"] floatValue]];
    
    lblEmissaoParticipante.text = [NSString stringWithFormat:@"Você deixou de emitir: %.2f ton. de CO2", [[dicResumo objectForKey:@"co2Usuario"] floatValue]];
    
    lblDesconsumoParticipante.text = [NSString stringWithFormat:@"Seu 'desconsumo' total: %.2f km", [[dicResumo objectForKey:@"kmUsuario"] floatValue]];
    
    lblEmissaoVamu.text = [NSString stringWithFormat:@"Deixamos de emitir: %.2f ton. de CO2", [[dicResumo objectForKey:@"co2Vamu"] floatValue]];
    
    lblDesconsumoVamu.text = [NSString stringWithFormat:@"'Desconsumo' TOTAL do Vamu: %.2f km", [[dicResumo objectForKey:@"kmVamu"] floatValue]];
    
}

@end
