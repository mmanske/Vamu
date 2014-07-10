//
//  CaronaConfirmarEmbarqueView.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participante.h"
#import "AceitacaoCarona.h"
#import "BaixarImagemService.h"

@protocol ConfirmarEmbarqueDelegate <NSObject>

-(void) embarcouCarona:(AceitacaoCarona*) solicitacao;
-(void) cancelouCarona:(AceitacaoCarona*) solicitacao;

@end

@interface CaronaConfirmarEmbarqueView : UIView{
    id <ConfirmarEmbarqueDelegate> delegate;
}

@property (nonatomic) id delegate;

-(id)exibirSolicitacao:(AceitacaoCarona*) solicitacao;
-(void)carregarImagemMotorista;

@property (strong, nonatomic) AceitacaoCarona *solicitacao;
@property (strong, nonatomic) BaixarImagemService *imagemService;

@property (strong, nonatomic) IBOutlet UILabel *lblNomeMotorista;
@property (strong, nonatomic) IBOutlet UILabel *lblModeloVeiculo;
@property (strong, nonatomic) IBOutlet UILabel *lblNumViagens;
@property (strong, nonatomic) IBOutlet UIImageView *imgMotorista;

- (IBAction)btnEmbarqueiClick:(id)sender;
- (IBAction)btnCancelarClick:(id)sender;

@end
