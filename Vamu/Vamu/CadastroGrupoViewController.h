//
//  CadastroGrupoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 05/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseViewController.h"
#import "Grupo.h"
#import "Participante.h"

@interface CadastroGrupoViewController : BaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *edtNome;
@property (strong, nonatomic) IBOutlet UITextField *edtDescricao;
@property (strong, nonatomic) IBOutlet UISwitch *swtGrupoVisivel;
@property (strong, nonatomic) IBOutlet UISwitch *swtReceberSolicitacao;
@property (strong, nonatomic) IBOutlet UISwitch *swtAtivarFiltros;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelar;
@property (strong, nonatomic) IBOutlet UIButton *btnSalvar;

- (IBAction)btnCancelarClick:(id)sender;
- (IBAction)btnSalvarClick:(id)sender;
- (IBAction)clicouTela:(id)sender;

@end
