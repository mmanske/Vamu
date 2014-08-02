//
//  RecuperarSenhaViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RecuperarSenhaService.h"
#import "SDCAlertView.h"

@interface RecuperarSenhaViewController : BaseViewController<UITextFieldDelegate, SDCAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *edtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnEnviar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)clicouTela:(id)sender;
- (IBAction)btnEnviarClick:(id)sender;
- (IBAction)clicouEdit:(id)sender;

@end
