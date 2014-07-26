//
//  ResumoMotoristaViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 15/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResumoCell.h"

@interface ResumoMotoristaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imgParticipante;
@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblOrigem;
@property (strong, nonatomic) IBOutlet UILabel *lblDestino;
@property (strong, nonatomic) IBOutlet UILabel *lblDesconsumoViagem;
@property (strong, nonatomic) IBOutlet UILabel *lblEmissaoViagem;
@property (strong, nonatomic) IBOutlet UILabel *lblDesconsumoParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblEmissaoParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblDesconsumoVamu;
@property (strong, nonatomic) IBOutlet UILabel *lblEmissaoVamu;

@end
