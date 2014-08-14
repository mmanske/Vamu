//
//  EditarParticipanteViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 12/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participante.h"
#import "CustomActivityView.h"
#import "KSEnhancedKeyboard.h"

@interface EditarParticipanteViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, KSEnhancedKeyboardDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgBg;
@property (strong, nonatomic) IBOutlet UITextField *edtCPF;
@property (strong, nonatomic) IBOutlet UITextField *edtSenha;
@property (strong, nonatomic) IBOutlet UITextField *edtConfirmarSenha;
@property (strong, nonatomic) IBOutlet UITextField *edtNomeParticipante;
@property (strong, nonatomic) IBOutlet UITextField *edtApelido;
@property (strong, nonatomic) IBOutlet UITextField *edtEmail;
@property (strong, nonatomic) IBOutlet UITextField *edtSexo;
@property (strong, nonatomic) IBOutlet UITextField *edtDataNascimento;
@property (strong, nonatomic) IBOutlet UITextField *edtCelular;
@property (strong, nonatomic) IBOutlet UIButton *btnInserirFoto;
@property (strong, nonatomic) IBOutlet UIImageView *imgParticipante;
@property (strong, nonatomic) IBOutlet UITextField *edtCEP;
@property (strong, nonatomic) IBOutlet UITextField *edtEndereco;
@property (strong, nonatomic) IBOutlet UITextField *edtNumero;
@property (strong, nonatomic) IBOutlet UITextField *edtComplemento;
@property (strong, nonatomic) IBOutlet UITextField *edtBairro;
@property (strong, nonatomic) IBOutlet UITextField *edtCidade;
@property (strong, nonatomic) IBOutlet UITextField *edtUF;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *edtTelefone;

- (IBAction)btnInserirFotoClick:(id)sender;
- (IBAction)btnSalvarClick:(id)sender;
- (IBAction)btnCancelarClick:(id)sender;

@end
