//
//  MainVC.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "AMSlideMenuMainViewController.h"

@protocol AtualizacaoDelegate <NSObject>

-(void) atualizacaoRecebeuNotificacoes:(NSMutableArray*) notificacoes;

@end

@interface MainVC : AMSlideMenuMainViewController

@end
