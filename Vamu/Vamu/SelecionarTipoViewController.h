//
//  SelecionarTipoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 22/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseViewController.h"
#import "Participante.h"
#import "DefinirTrajetoViewController.h"

@interface SelecionarTipoViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIButton *btnTrocarUsuario;
@property (strong, nonatomic) IBOutlet UIButton *btnTrocarVeiculo;
@property (strong, nonatomic) IBOutlet UIButton *btnMotorista;
@property (strong, nonatomic) IBOutlet UIButton *btnCarona;
@property (strong, nonatomic) IBOutlet UIImageView *imgFoto;
@property (strong, nonatomic) IBOutlet UILabel *lblNome;
@property (strong, nonatomic) IBOutlet UILabel *lblCarro;
@property (strong, nonatomic) IBOutlet UILabel *lblPlaca;
@property (strong, nonatomic) Participante *participanteLogado;
@property (strong, nonatomic) IBOutlet UIView *viewQtdMotorista;
@property (strong, nonatomic) IBOutlet UIView *viewQtdCarona;
@property (strong, nonatomic) IBOutlet UILabel *lblQtdMotorista;
@property (strong, nonatomic) IBOutlet UILabel *lblQtdCarona;

- (IBAction)btnMotoristaClick:(id)sender;
- (IBAction)btnCaronaClick:(id)sender;
- (IBAction)btnSairClick:(id)sender;

@end
