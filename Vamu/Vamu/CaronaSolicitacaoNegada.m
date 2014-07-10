//
//  CaronaSolicitacaoNegada.m
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CaronaSolicitacaoNegada.h"
#import "AppHelper.h"

@implementation CaronaSolicitacaoNegada

@synthesize lblModeloVeiculo, lblMotivoRecusa, lblNomeMotorista, lblNumViagens, imgMotorista, solicitacao = _solicitacao, imagemService;

-(id)exibirSolicitacao:(NegacaoCarona*) solicitacao{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CaronaSolicitacaoNegada" owner:self options:nil];
    CaronaSolicitacaoNegada *mainView = [subviewArray objectAtIndex:0];
    
    mainView.imgMotorista.layer.cornerRadius = mainView.imgMotorista.bounds.size.width/2;
    mainView.imgMotorista.layer.masksToBounds = YES;
    mainView.imgMotorista.layer.borderWidth = 2;
    mainView.imgMotorista.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mainView.imgMotorista.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    mainView.solicitacao = solicitacao;
    mainView.lblNomeMotorista.text = _solicitacao.remetente.nome;
    mainView.lblModeloVeiculo.text = [NSString stringWithFormat:@"%@ - %@ - %@ - %@", _solicitacao.modeloVeiculo, _solicitacao.ano, _solicitacao.cor, _solicitacao.placa];
    mainView.lblNumViagens.text = [NSString stringWithFormat:@"%@ viagem(ns)", _solicitacao.numViagensMotorista];
    mainView.lblMotivoRecusa.text = solicitacao.mensagem;
    
    return mainView;
}

- (IBAction)btnRecusaClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmarNegada:)]) {
        [self.delegate confirmarNegada:_solicitacao];
    }
    [self removeFromSuperview];
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
