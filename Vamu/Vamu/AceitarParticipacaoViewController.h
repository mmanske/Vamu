//
//  AceitarParticipacaoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 01/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AceitarParticipacaoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblNomeGrupo;
@property (strong, nonatomic) IBOutlet UIImageView *imgParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblEstatisticasParticipante;

- (IBAction)btnRecusarClick:(id)sender;
- (IBAction)btnAceitarClick:(id)sender;

@end
