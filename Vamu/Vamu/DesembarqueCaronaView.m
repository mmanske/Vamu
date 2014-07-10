//
//  DesembarqueCaronaView.m
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "DesembarqueCaronaView.h"
#import "AppHelper.h"

@implementation DesembarqueCaronaView

@synthesize btnDesembarquei, lblKM, delegate, caronaService;

-(id) iniciar{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"DesembarqueCaronaView" owner:self options:nil];
    DesembarqueCaronaView *mainView = [subviewArray objectAtIndex:0];
    
    return mainView;
}

- (IBAction)btnDesembarqueiClick:(id)sender {
    caronaService = [CaronaService new];
    caronaService.delegate = self;
    [caronaService desembarqueCarona:[AppHelper getParticipanteLogado]];
}

#pragma mark - CaronaServiceDelegate

-(void)desembarqueConcluido{
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(desembarquei)]) {
        [self.delegate desembarquei];
    }
}

@end
