//
//  SolicitacaoView.h
//  Vamu
//
//  Created by Guilherme Augusto on 15/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolicitacaoCarona.h"
#import "CaronaService.h"

@protocol SolicitacaoViewDelegate <NSObject>

-(void) aceitarSolicitacao:(SolicitacaoCarona*) solicitacao;
-(void) recusarSolicitacao:(SolicitacaoCarona*) solicitacao;

@end

@interface SolicitacaoView : UIView{
    id <SolicitacaoViewDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UIButton *btnRecusar;
@property (strong, nonatomic) IBOutlet UIButton *btnVamu;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblNumViajens;
@property (strong, nonatomic) IBOutlet UIImageView *imgParticipante;
@property (strong, nonatomic) SolicitacaoCarona *solicitacao;
@property (strong, nonatomic) CaronaService *caronaService;
@property (nonatomic) id delegate;

- (IBAction)btnVamuClick:(id)sender;
- (IBAction)btnRecusarClick:(id)sender;

-(id) iniciar;

@end
