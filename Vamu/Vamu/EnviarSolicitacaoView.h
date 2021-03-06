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
-(void) solicitouCarona:(NSString*) cod;

@end

@interface EnviarSolicitacaoView : UIView{
    id <EnviarSolicitacaoViewDelegate> delegate;
}

@property (strong, nonatomic) NSString *codigo;
@property (strong, nonatomic) MotoristaAtivo *motorista;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblCarro;
@property (strong, nonatomic) IBOutlet UILabel *lblDistancia;
@property (strong, nonatomic) IBOutlet UIImageView *imgMotorista;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelar;
@property (strong, nonatomic) IBOutlet UIButton *btnVamu;
@property (nonatomic) id delegate;

- (void)iniciar;
- (IBAction)btnVamuClick:(id)sender;
- (IBAction)btnCancelarClick:(id)sender;

@end
