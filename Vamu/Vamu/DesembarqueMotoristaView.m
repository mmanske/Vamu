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

@synthesize delegate, lblDestinoCarona, lblNomeCarona, imgCarona, carona, caronaService;

@synthesize btnCancelou, btnDesembarcou, btnEmbarcou;

-(id)iniciarSolicitacao:(SolicitacaoCarona *)solicitacao{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"DesembarqueMotoristaView" owner:self options:nil];
    DesembarqueMotoristaView *mainView = [subviewArray objectAtIndex:0];
    
    mainView.carona = solicitacao.remetente;
    mainView.lblNomeCarona.text = mainView.carona.nome;
    mainView.lblDestinoCarona.text = solicitacao.nomeDestino;
    mainView.carona.latitudeAtual = [NSNumber numberWithFloat:[solicitacao.latitudeRemetente floatValue]];
    mainView.carona.longitudeAtual = [NSNumber numberWithFloat:[solicitacao.longitudeRemetente floatValue]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", mainView.carona.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    mainView.imgCarona.image = [UIImage imageWithContentsOfFile:imageFileName];
    
    
    [mainView setBackgroundColor:[UIColor colorWithRed:0.4 green:0.667 blue:0.267 alpha:1.0]];
    
    return mainView;
}


- (IBAction)btnDesembarcouClick:(id)sender {
    caronaService = [CaronaService new];
    caronaService.delegate = self;
    [caronaService desembarqueCarona:carona];
}

- (IBAction)btnEmbarcouClick:(id)sender {
    caronaService = [CaronaService new];
    caronaService.delegate = self;
    [caronaService confirmarEmbarque:carona];
    
}

- (IBAction)btnCancelouEmbarqueClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelouEmbarque:)]) {
        [self.delegate cancelouEmbarque:carona];
    }
}

#pragma mark - CaronaServiceDelegate

-(void)caronaAindaNaoEmbarcou{
    [[[UIAlertView alloc] initWithTitle:@"Embarque de Carona" message:@"Carona ainda não confirmou o Embarque" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)embarqueConcluido{
    btnEmbarcou.hidden = btnCancelou.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(embarcou:)]) {
        [self.delegate embarcou:carona];
    }
}

-(void)desembarqueConcluido{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(desembarcou:)]) {
        [self.delegate desembarcou:carona];
    }
}

@end
