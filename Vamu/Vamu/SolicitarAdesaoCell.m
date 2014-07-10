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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)solicitouAdesao:(id)sender {
    if (swtSolicitar.on) {
        if (self.delegate && [delegate respondsToSelector:@selector(onSolicitouParticipacao:)]) {
            [self.delegate onSolicitouParticipacao:grupo];
        }
    }
}

@end
