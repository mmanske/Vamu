//
//  EnviarSolicitacaoView.m
//  Vamu
//
//  Created by Guilherme Augusto on 16/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "EnviarSolicitacaoView.h"
#import "Veiculo.h"
#import "BaixarImagemService.h"
#import "AppHelper.h"

@implementation EnviarSolicitacaoView

@synthesize lblNomeParticipante, lblCarro, lblDistancia, imgMotorista, btnCancelar, btnVamu, motorista, codigo;

-(void) iniciar{
    imgMotorista.layer.cornerRadius = imgMotorista.bounds.size.width/2;
    imgMotorista.layer.masksToBounds = YES;
    imgMotorista.layer.borderWidth = 2;
    imgMotorista.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imgMotorista.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    lblNomeParticipante.text = motorista.nomeMotorista;
    lblCarro.text = [NSString stringWithFormat:@"%@ %@ - %@ - Placa %@", motorista.veiculo.modelo, motorista.veiculo.ano, motorista.veiculo.cor, motorista.veiculo.placa];
    lblDistancia.text = [NSString stringWithFormat:@"%d viagens / %.2f km, %.0f min.", [motorista.quantViagens intValue], [motorista.distMetros floatValue]/10, [motorista.distSegundos floatValue] / 60];
    
    BaixarImagemService *baixarImagem = [BaixarImagemService new];
    baixarImagem.delegate = self;
    [baixarImagem baixarImagemDePessoa:motorista.cpf];
}

- (IBAction)btnVamuClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(solicitouCarona:)]) {
        [self.delegate solicitouCarona:codigo];
    }
    [self removeFromSuperview];
}

- (IBAction)btnCancelarClick:(id)sender {
    [self removeFromSuperview];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

-(void)finalizaBaixarImagem{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", motorista.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    
    imgMotorista.image = [UIImage imageWithContentsOfFile:imageFileName];
}

@end
