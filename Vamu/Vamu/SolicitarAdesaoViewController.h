//
//  SolicitarAdesaoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 05/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseViewController.h"
#import "SolicitarAdesaoCell.h"

@interface SolicitarAdesaoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SolicitarAdesaoCellDelegate>

@property (strong, nonatomic) IBOutlet UITextField *edtNomeGrupo;
@property (strong, nonatomic) IBOutlet UITableView *tabela;

@end
