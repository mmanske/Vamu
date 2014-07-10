//
//  SolicitacaoAceitaView.m
//  Vamu
//
//  Created by Guilherme Augusto on 10/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "SolicitacaoAceitaView.h"
#import "AppHelper.h"

@implementation SolicitacaoAceitaView

@synthesize lblNome, lblNomeCarro, lblViagens, imgMotorista, solicitacao = _solicitacao, imagemService;

-(id)exibirSolicitacao:(AceitacaoCarona*) solicitacao{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"SolicitacaoAceitaView" owner:self options:nil];
    SolicitacaoAceitaView *mainView = [subviewArray objectAtIndex:0];
    
    mainView.imgMotorista.layer.cornerRadius = mainView.imgMotorista.bounds.size.width/2;
    mainView.imgMotorista.layer.masksToBounds = YES;
    mainView.imgMotorista.layer.borderWidth = 2;
    mainView.imgMotorista.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mainView.imgMotorista.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    mainView.solicitacao = solicitacao;
    mainView.lblNome.text = solicitacao.remetente.nome;
    mainView.lblNomeCarro.text = [NSString stringWithFormat:@"%@ - %@ - %@ - %@", solicitacao.modeloVeiculo, solicitacao.ano, solicitacao.cor, solicitacao.placa];
    mainView.lblViagens.text = [NSString stringWithFormat:@"%@", solicitacao.numViagensMotorista];
    
    return mainView;
}

- (IBAction)btnVamuClick:(id)sender {
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
