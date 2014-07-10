//
//  CancelarParticipacaoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 20/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultaGrupoService.h"
#import "SolicitarAdesaoCell.h"

@interface CancelarParticipacaoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SolicitarAdesaoCellDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tabela;

@end
