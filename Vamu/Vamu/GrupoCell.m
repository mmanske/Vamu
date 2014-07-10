//
//  GrupoCell.m
//  Vamu
//
//  Created by Guilherme Augusto on 20/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "GrupoCell.h"

@implementation GrupoCell

@synthesize lblNomeGrupo, swtAtivo, delegate, grupoAtual;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)trocouStatus:(id)sender {
    if (swtAtivo.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoCellAtivouGrupo:)]) {
            [self.delegate grupoCellAtivouGrupo:grupoAtual];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(grupoCellDesativouGrupo:)]) {
            [self.delegate grupoCellDesativouGrupo:grupoAtual];
        }
    }
}

@end
