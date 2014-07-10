//
//  EnviarSolicitacaoView.h
//  Vamu
//
//  Created by Guilherme Augusto on 16/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolicitacaoCarona.h"
#import "MotoristaAtivo.h"

@protocol EnviarSolicitacaoViewDelegate <NSObject>

-(void) enviarSolicitacao:(SolicitacaoCarona*) solicitacao;

@end

@interface EnviarSolicitacaoView : UIView

@property (strong, nonatomic) MotoristaAtivo *motorista;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblCarro;
@property (strong, nonatomic) IBOutlet UILabel *lblDistancia;
@property (strong, nonatomic) IBOutlet UIImageView *imgMotorista;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelar;
@property (strong, nonatomic) IBOutlet UIButton *btnVamu;

-(void) iniciar;
- (IBAction)btnVamuClick:(id)sender;
- (IBAction)btnCancelarClick:(id)sender;

@end
