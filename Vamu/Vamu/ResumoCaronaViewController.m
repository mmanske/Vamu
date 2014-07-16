//
//  ResumoCaronaViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 15/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ResumoCaronaViewController.h"

@interface ResumoCaronaViewController ()

@end

@implementation ResumoCaronaViewController

@synthesize lblCarro, lblDataViagem, lblDesconsumoParticipante, lblDesconsumoVamu ,lblDesconsumoViagem, lblDestino, lblEmissaoParticipante, lblEmissaoVamu, lblEmissaoViagem, lblNomeMotorista, lblNomeParticipante, lblOrigem, lblPlaca, lblResumoViagem, imgMotorista, imgParticipante;

- (void)viewDidLoad
{
    [super viewDidLoad];
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 1;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    imgMotorista.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgMotorista.layer.masksToBounds = YES;
    imgMotorista.layer.borderWidth = 1;
    imgMotorista.layer.borderColor = [UIColor whiteColor].CGColor;
    imgMotorista.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
