//
//  ResumoCaronaViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 15/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumoCaronaViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgParticipante;
@property (weak, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (weak, nonatomic) IBOutlet UILabel *lblResumoViagem;
@property (weak, nonatomic) IBOutlet UILabel *lblDataViagem;
@property (weak, nonatomic) IBOutlet UILabel *lblOrigem;
@property (weak, nonatomic) IBOutlet UILabel *lblDestino;
@property (weak, nonatomic) IBOutlet UIImageView *imgMotorista;
@property (weak, nonatomic) IBOutlet UILabel *lblNomeMotorista;
@property (weak, nonatomic) IBOutlet UILabel *lblCarro;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaca;

@property (weak, nonatomic) IBOutlet UILabel *lblDesconsumoViagem;
@property (weak, nonatomic) IBOutlet UILabel *lblEmissaoViagem;

@property (weak, nonatomic) IBOutlet UILabel *lblDesconsumoParticipante;
@property (weak, nonatomic) IBOutlet UILabel *lblEmissaoParticipante;

@property (weak, nonatomic) IBOutlet UILabel *lblDesconsumoVamu;
@property (weak, nonatomic) IBOutlet UILabel *lblEmissaoVamu;

@end
