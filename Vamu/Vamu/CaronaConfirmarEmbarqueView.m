//
//  CaronaConfirmarEmbarqueView.m
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CaronaConfirmarEmbarqueView.h"
#import "AppHelper.h"

@implementation CaronaConfirmarEmbarqueView

@synthesize lblModeloVeiculo, lblNomeMotorista, lblNumViagens, imgMotorista, solicitacao = _solicitacao, imagemService;

-(id)exibirSolicitacao:(AceitacaoCarona*) solicitacao{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CaronaConfirmarEmbarqueView" owner:self options:nil];
    CaronaConfirmarEmbarqueView *mainView = [subviewArray objectAtIndex:0];
    
    mainView.imgMotorista.layer.cornerRadius = mainView.imgMotorista.bounds.size.width/2;
    mainView.imgMotorista.layer.masksToBounds = YES;
    mainView.imgMotorista.layer.borderWidth = 2;
    mainView.imgMotorista.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mainView.imgMotorista.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    mainView.solicitacao = solicitacao;
    mainView.lblNomeMotorista.text = solicitacao.remetente.nome;
    mainView.lblModeloVeiculo.text = [NSString stringWithFormat:@"%@ - %@ - %@ - %@", solicitacao.modeloVeiculo, solicitacao.ano, solicitacao.cor, solicitacao.placa];
    mainView.lblNumViagens.text = [NSString stringWithFormat:@"%@ viagem(ns)", solicitacao.numViagensMotorista];
    
    return mainView;
}

- (IBAction)btnEmbarqueiClick:(id)sender {
    [self removeFromSuperview];
    [[AppHelper getParticipanteLogado] setCodViagemAtual:[NSNumber numberWithInt:[_solicitacao.codViagem intValue]]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(embarcouCarona:)]) {
        [self.delegate embarcouCarona: _solicitacao];
    }
}

- (IBAction)btnCancelarClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelouCarona:)]) {
        [self.delegate cancelouCarona:_solicitacao];
    }
}

-(void)finalizaBaixarImagem{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", _solicitacao.remetente.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    self.imgMotorista.image = [UIImage imageWithContentsOfFile:imageFileName];
}

-(void)carregarImagemMotorista{
    imagemService = [BaixarImagemService new];
    imagemService.delegate = self;
    [imagemService baixarImagemDePessoa:_solicitacao.remetente.cpf];
}

@end
