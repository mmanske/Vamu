//
//  LeftMenuVC.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"
#import "Participante.h"

@interface LeftMenuVC : AMSlideMenuLeftTableViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (strong, nonatomic) Participante *participanteLogado;
- (IBAction)btnSairClick:(id)sender;

@end
