//
//  CadastroParticipanteViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 12/04/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Participante.h"
#import "CadastroVeiculoViewController.h"
#import "ParticipanteService.h"
#import "KSEnhancedKeyboard.h"

@interface CadastroParticipanteViewController : BaseViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, KSEnhancedKeyboardDelegate>


@property (strong, nonatomic) NSString *cpf;
@property (strong, nonatomic) NSString *senha;

#pragma mark - Controles
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackGround;
@property (strong, nonatomic) IBOutlet UIButton *btnSalvar;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelar;
@property (strong, nonatomic) IBOutlet UIButton *btnInserirFoto;

#pragma mark - Dados Pessoais
@property (strong, nonatomic) IBOutlet UITextField *edtCPF;
@property (strong, nonatomic) IBOutlet UITextField *edtSenha;
@property (strong, nonatomic) IBOutlet UITextField *edtConfirmarSenha;
@property (strong, nonatomic) IBOutlet UITextField *edtNome;
@property (strong, nonatomic) IBOutlet UITextField *edtApelido;
@property (strong, nonatomic) IBOutlet UITextField *edtEmail;
@property (strong, nonatomic) IBOutlet UITextField *edtSexo;
@property (strong, nonatomic) IBOutlet UITextField *edtNascimento;
@property (strong, nonatomic) IBOutlet UITextField *edtCelular;
@property (strong, nonatomic) IBOutlet UIImageView *foto;


#pragma mark - Endereco
@property (strong, nonatomic) IBOutlet UITextField *edtCEP;
@property (strong, nonatomic) IBOutlet UITextField *edtEndereco;
@property (strong, nonatomic) IBOutlet UITextField *edtNumero;
@property (strong, nonatomic) IBOutlet UITextField *edtComplemento;
@property (strong, nonatomic) IBOutlet UITextField *edtBairro;
@property (strong, nonatomic) IBOutlet UITextField *edtCidade;
@property (strong, nonatomic) IBOutlet UITextField *edtUF;

#pragma mark - Actions
- (IBAction)btnSalvarClick:(id)sender;
- (IBAction)btnCancelarClick:(id)sender;
- (IBAction)btnInserirFotoClick:(id)sender;

@end
