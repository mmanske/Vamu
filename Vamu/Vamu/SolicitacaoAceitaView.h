//
//  SolicitacaoAceitaView.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AceitacaoCarona.h"
#import "Participante.h"
#import "BaixarImagemService.h"
#import "NotificacaoService.h"

@interface SolicitacaoAceitaView : UIView

-(id)exibirSolicitacao:(AceitacaoCarona*) solicitacao;

@property (strong, nonatomic) AceitacaoCarona *solicitacao;
@property (strong, nonatomic) BaixarImagemService *imagemService;
@property (strong, nonatomic) NotificacaoService *notificacaoService;

@property (strong, nonatomic) IBOutlet UILabel *lblNome;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeCarro;
@property (strong, nonatomic) IBOutlet UILabel *lblViagens;
@property (strong, nonatomic) IBOutlet UIImageView *imgMotorista;

- (IBAction)btnVamuClick:(id)sender;
- (void) carregarImagemMotorista;

@end
