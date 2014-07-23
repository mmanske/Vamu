//
//  LoginViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 10/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTextFieldNumberPad.h"
#import "KSEnhancedKeyboard.h"

@interface LoginViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate, KSEnhancedKeyboardDelegate>

@property (strong, nonatomic) IBOutlet AMTextFieldNumberPad *edtCPF;
@property (strong, nonatomic) IBOutlet UITextField *edtSenha;
@property (strong, nonatomic) IBOutlet UIView *viewCampos;
@property (strong, nonatomic) IBOutlet UIButton *btnEntrar;
@property (weak, nonatomic) IBOutlet UILabel *lblVersao;

- (IBAction)clicouTela:(id)sender;
- (IBAction)btnEntrarClick:(id)sender;
- (IBAction)btnCadastreseClick:(id)sender;

@end
