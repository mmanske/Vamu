//
//  CaronaSolicitacaoNegada.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participante.h"
#import "NegacaoCarona.h"
#import "BaixarImagemService.h"

@protocol CaronaNegadaDelegate <NSObject>

-(void) confirmarSolicitacao:(NegacaoCarona*) solicitacao;

@end

@interface CaronaSolicitacaoNegada : UIView{
    id <CaronaNegadaDelegate> delegate;
}

-(id)exibirSolicitacao:(NegacaoCarona*) solicitacao;

@property (strong, nonatomic) NegacaoCarona *solicitacao;
@property (strong, nonatomic) BaixarImagemService *imagemService;

@property (strong, nonatomic) IBOutlet UILabel *lblNomeMotorista;
@property (strong, nonatomic) IBOutlet UILabel *lblModeloVeiculo;
@property (strong, nonatomic) IBOutlet UILabel *lblNumViagens;
@property (strong, nonatomic) IBOutlet UIImageView *imgMotorista;
@property (strong, nonatomic) IBOutlet UILabel *lblMotivoRecusa;

@property (nonatomic) id delegate;

-(void) carregarImagemMotorista;
- (IBAction)btnRecusaClick:(id)sender;

@end
