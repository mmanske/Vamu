//
//  EnviarConviteViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 16/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrupoService.h"

@interface EnviarConviteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property (weak, nonatomic) IBOutlet UITextField *edtEmail;

- (IBAction)btnCancelarClick:(id)sender;
- (IBAction)btnEnviarClick:(id)sender;


@end
