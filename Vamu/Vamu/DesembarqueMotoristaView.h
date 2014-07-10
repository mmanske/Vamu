//
//  DesembarqueMotoristaView.h
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participante.h"
#import "SolicitacaoCarona.h"
#import "CaronaService.h"

@protocol DesembarqueMotoristaViewDelegate <NSObject>

-(void) desembarcou:(Participante*) participante;
-(void) embarcou:(Participante*) participante;
-(void) cancelouEmbarque:(Participante*) participante;

@end

@interface DesembarqueMotoristaView : UIView{
    id <DesembarqueMotoristaViewDelegate> delegate;
}

@property (nonatomic) id delegate;

-(id) iniciarSolicitacao:(SolicitacaoCarona*) solicitacao;

@property (weak, nonatomic) IBOutlet UIImageView *imgCarona;
@property (weak, nonatomic) IBOutlet UILabel *lblNomeCarona;
@property (weak, nonatomic) IBOutlet UILabel *lblDestinoCarona;
@property (weak, nonatomic) IBOutlet UIButton *btnDesembarcou;
@property (strong, nonatomic) Participante *carona;
@property (strong, nonatomic) IBOutlet UIButton *btnEmbarcou;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelou;
@property (strong, nonatomic) SolicitacaoCarona *solicitacao;
@property (strong, nonatomic) CaronaService *caronaService;

- (IBAction)btnDesembarcouClick:(id)sender;
- (IBAction)btnEmbarcouClick:(id)sender;
- (IBAction)btnCancelouEmbarqueClick:(id)sender;


@end
