//
//  DesembarqueMotoristaView.m
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "DesembarqueMotoristaView.h"
#import "AppHelper.h"

@implementation DesembarqueMotoristaView

@synthesize delegate, lblDestinoCarona, lblNomeCarona, imgCarona, carona;

@synthesize btnCancelou, btnDesembarcou, btnEmbarcou;

-(id)iniciarSolicitacao:(SolicitacaoCarona *)solicitacao{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"DesembarqueMotoristaView" owner:self options:nil];
    DesembarqueMotoristaView *mainView = [subviewArray objectAtIndex:0];
    
    mainView.carona = solicitacao.remetente;
    mainView.lblNomeCarona.text = mainView.carona.nome;
    mainView.lblDestinoCarona.text = solicitacao.nomeDestino;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", mainView.carona.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    imgCarona.image = [UIImage imageWithContentsOfFile:imageFileName];
    
    
    [mainView setBackgroundColor:[UIColor colorWithRed:0.4 green:0.667 blue:0.267 alpha:1.0]];
    
    return mainView;
}

-(id) iniciarComParticipante:(Participante *)participante{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"DesembarqueMotoristaView" owner:self options:nil];
    DesembarqueMotoristaView *mainView = [subviewArray objectAtIndex:0];
    
    mainView.carona = participante;
    mainView.lblNomeCarona.text = participante.nome;
    mainView.lblDestinoCarona.text = @"Av. Das Américas";

    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", participante.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    imgCarona.image = [UIImage imageWithContentsOfFile:imageFileName];
    
    
    [mainView setBackgroundColor:[UIColor colorWithRed:0.4 green:0.667 blue:0.267 alpha:1.0]];
    
    return mainView;
}

- (IBAction)btnDesembarcouClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(desembarcou:)]) {
        [self.delegate desembarcou:carona];
    }
}

- (IBAction)btnEmbarcouClick:(id)sender {
    btnEmbarcou.hidden = btnCancelou.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(embarcou:)]) {
        [self.delegate embarcou:carona];
    }
}

- (IBAction)btnCancelouEmbarqueClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelouEmbarque:)]) {
        [self.delegate cancelouEmbarque:carona];
    }
}

@end
