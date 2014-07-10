//
//  EditarVeiculoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 31/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seguradora.h"
#import "SeguradoraService.h"

@interface EditarVeiculoViewController : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *edtPlaca;
@property (strong, nonatomic) IBOutlet UITextField *edtRenavam;
@property (strong, nonatomic) IBOutlet UITextField *edtMarca;
@property (strong, nonatomic) IBOutlet UITextField *edtModelo;
@property (strong, nonatomic) IBOutlet UITextField *edtCor;
@property (strong, nonatomic) IBOutlet UITextField *edtAno;
@property (strong, nonatomic) IBOutlet UITextField *edtSegurador;
@property (strong, nonatomic) IBOutlet UIImageView *imgCarro;

- (IBAction)btnInserirFotoClick:(id)sender;
- (IBAction)btnCancelarClick:(id)sender;
- (IBAction)btnSalvarClick:(id)sender;

@end
