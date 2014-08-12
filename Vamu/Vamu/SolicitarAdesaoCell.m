//
//  SolicitarAdesaoCell.m
//  Vamu
//
//  Created by Guilherme Augusto on 05/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "SolicitarAdesaoCell.h"

@implementation SolicitarAdesaoCell

@synthesize swtSolicitar;
@synthesize grupo;
@synthesize delegate;
@synthesize index;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)solicitouAdesao:(id)sender {
    if (self.delegate && [delegate respondsToSelector:@selector(onSolicitouParticipacao:index:valor:)]){
        [self.delegate onSolicitouParticipacao:grupo index:index valor:swtSolicitar.on];
    }
}

@end
