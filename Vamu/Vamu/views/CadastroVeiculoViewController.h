//
//  CadastroVeiculoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 17/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Veiculo.h"
#import "CSNotificationView.h"
#import "BaseViewController.h"
#import "Participante.h"
#import "VeiculoService.h"
#import "CustomActivityView.h"
#import "Seguradora.h"
#import "SeguradoraService.h"
#import "KSEnhancedKeyboard.h"


@interface CadastroVeiculoViewController : BaseViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, KSEnhancedKeyboardDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *edtPlaca;
@property (weak, nonatomic) IBOutlet UITextField *edtRenavan;
@property (weak, nonatomic) IBOutlet UITextField *edtMarca;
@property (weak, nonatomic) IBOutlet UITextField *edtModelo;
@property (weak, nonatomic) IBOutlet UITextField *edtCor;
@property (weak, nonatomic) IBOutlet UITextField *edtAno;
@property (weak, nonatomic) IBOutlet UITextField *edtSeguradora;
@property (weak, nonatomic) IBOutlet UIImageView *imgCarro;
@property (strong, nonatomic) Participante *proprietario;
@property (strong, nonatomic) Veiculo *veiculo;
@property BOOL imagemCarregada;

- (IBAction)btnAdicionarFotoClick:(id)sender;
- (IBAction)btnSalvarClick:(id)sender;
- (IBAction)btnCancelarClick:(id)sender;
- (IBAction)clicouTela:(id)sender;



@end
