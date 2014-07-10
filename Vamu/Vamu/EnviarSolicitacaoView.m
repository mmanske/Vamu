//
//  EnviarSolicitacaoView.m
//  Vamu
//
//  Created by Guilherme Augusto on 16/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "EnviarSolicitacaoView.h"

@implementation EnviarSolicitacaoView

@synthesize lblNomeParticipante, lblCarro, lblDistancia, imgMotorista, btnCancelar, btnVamu, motorista;

-(void) iniciar{
    lblNomeParticipante.text = motorista.descViagem;
}

- (IBAction)btnVamuClick:(id)sender {
}

- (IBAction)btnCancelarClick:(id)sender {
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

@end
