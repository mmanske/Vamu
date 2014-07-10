//
//  SolicitacaoView.m
//  Vamu
//
//  Created by Guilherme Augusto on 15/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "SolicitacaoView.h"
#import "Participante.h"
#import "AppHelper.h"

@implementation SolicitacaoView

@synthesize lblNomeParticipante, lblNumViajens, imgParticipante , btnRecusar, btnVamu, solicitacao, delegate, imagemService;

-(id)iniciar{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"SolicitacaoView" owner:self options:nil];
    SolicitacaoView *mainView = [subviewArray objectAtIndex:0];
    
    mainView.imgParticipante.layer.cornerRadius = mainView.imgParticipante.bounds.size.width/2;
    mainView.imgParticipante.layer.masksToBounds = YES;
    mainView.imgParticipante.layer.borderWidth = 2;
    mainView.imgParticipante.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mainView.imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    return mainView;
}

- (IBAction)btnVamuClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aceitarSolicitacao:)]) {
        [self.delegate aceitarSolicitacao:solicitacao];
    }
}

- (IBAction)btnRecusarClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recusarSolicitacao:)]) {
        [self.delegate recusarSolicitacao:solicitacao];
    }
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

-(void)carregarImagemCarona{
    imagemService = [BaixarImagemService new];
    imagemService.delegate = self;
    
    [imagemService baixarImagemDePessoa:solicitacao.remetente.cpf];
}

-(void)finalizaBaixarImagem{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", solicitacao.remetente.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    self.imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];
}

@end
