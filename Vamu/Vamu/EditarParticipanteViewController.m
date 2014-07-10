//
//  EditarParticipanteViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 12/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "EditarParticipanteViewController.h"
#import "ParticipanteService.h"
#import "AppHelper.h"
#import "MascaraHelper.h"
#import "CSNotificationView.h"
#import "Validations.h"


@interface EditarParticipanteViewController (){
    BOOL imagemCarregada;
    UIDatePicker *pickerNascimento;
    UIPickerView *pickerSexo;
    NSArray *sexos;
}

@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) ParticipanteService *participanteService;
@property (nonatomic, strong) Participante *participante;
@property (strong, nonatomic) MascaraHelper *mascaraHelper;
@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;
@property (nonatomic) NSMutableArray *formItems;


@end

@implementation EditarParticipanteViewController

@synthesize participante;
@synthesize edtApelido, edtBairro, edtCelular, edtCEP, edtCidade, edtComplemento, edtConfirmarSenha, edtCPF, edtDataNascimento, edtEmail, edtEndereco, edtNomeParticipante, edtNumero, edtSenha, edtSexo, edtTelFixo, edtUF;
@synthesize scrollView;
@synthesize imgBg, imgParticipante, enhancedKeyboard;
@synthesize ampulheta;
@synthesize participanteService, mascaraHelper, formItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.formItems = [NSMutableArray new];
    UIView *subView = [self.view viewWithTag:88];
    
    for (UIView *view in [subView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [formItems addObject:view];
        }
    }
    
    subView = [self.view viewWithTag:89];
    
    for (UIView *view in [subView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [formItems addObject:view];
        }
    }
    
    self.enhancedKeyboard = [KSEnhancedKeyboard new];
    self.enhancedKeyboard.delegate = self;

    
    sexos = @[@"Masculino", @"Feminino"];
    
    participante = [AppHelper getParticipanteLogado];
    if (participante) {
        [self carregarDadosParticipante];
    }
    
    pickerNascimento = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 230, 0)];
    pickerNascimento.datePickerMode = UIDatePickerModeDate;
    [pickerNascimento addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
    
    edtDataNascimento.inputView = pickerNascimento;
    
    pickerSexo = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 230, 0)];
    pickerSexo.delegate = self;
    pickerSexo.dataSource = self;
    
    edtSexo.inputView = pickerSexo;
    
    scrollView.contentSize=CGSizeMake(320,1020);
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 2;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    edtApelido.delegate = edtBairro.delegate = edtCelular.delegate = edtCEP.delegate = edtCidade.delegate = edtComplemento.delegate = edtConfirmarSenha.delegate = edtCPF.delegate = edtEmail.delegate = edtEndereco.delegate = edtTelFixo.delegate = edtDataNascimento.delegate = edtNomeParticipante.delegate = edtNumero.delegate = edtSenha.delegate = edtSexo.delegate = edtUF.delegate = self;
    
    ampulheta = [CustomActivityView new];
    
    participanteService = [ParticipanteService new];
    participanteService.delegate = self;
    
    mascaraHelper = [MascaraHelper new];    
    
}

-(void) getDate:(UIDatePicker *) sender{
    NSDate *currentDate = sender.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    edtDataNascimento.text = [formatter stringFromDate:currentDate];
}

-(void) carregarDadosParticipante{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", participante.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];

    
    
    edtApelido.text = participante.apelido;
    edtBairro.text = participante.bairro;
    edtCelular.text = participante.celular;
    edtCEP.text = participante.cep;
    edtCidade.text = participante.cidade;
    edtComplemento.text = participante.complemento;
    edtConfirmarSenha.text = participante.senha;
    edtCPF.text = participante.cpf;
    edtDataNascimento.text = participante.nascimento;
    edtEmail.text = participante.email;
    edtEndereco.text = participante.endereco;
    edtNomeParticipante.text = participante.nome;
    edtNumero.text = participante.numero;
    edtSenha.text = participante.senha;
    edtSexo.text = [participante.sexo isEqualToNumber:[NSNumber numberWithInt:0]] ? @"Masculino" : @"Feminino";
    edtTelFixo.text = participante.fixo;
    edtUF.text = participante.uf;
}

-(BOOL) validouCampos{
    
    if ([edtCPF.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo CPF"];
        return NO;
    }
    if (![Validations validateCPFWithNSString: [AppHelper limparCPF:edtCPF.text]]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"CPF inválido"];
        return NO;
    }
    if ([edtSenha.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo senha"];
        return NO;
    }
    if ([edtConfirmarSenha.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo confirmar senha"];
        return NO;
    }
    if ([edtNomeParticipante.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo nome"];
        return NO;
    }
    if ([edtApelido.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo apelido"];
        return NO;
    }
    if ([edtEmail.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo email"];
        return NO;
    }
    if ([edtSexo.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo sexo"];
        return NO;
    }
    if ([edtDataNascimento.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo nascimento"];
        return NO;
    }
    if ([edtCelular.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo celular"];
        return NO;
    }
    if ([edtTelFixo.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo fixo"];
        return NO;
    }
    if (![edtSenha.text isEqualToString:edtConfirmarSenha.text]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Senha não confere"];
        return NO;
    }
    
    if (!imagemCarregada) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Selecione uma foto"];
        return NO;
    }
    
    if ([edtCEP.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo CEP"];
        return NO;
    }
    if ([edtEndereco.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo endereço"];
        return NO;
    }
    if ([edtNumero.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo número"];
        return NO;
    }
    if ([edtBairro.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo bairro"];
        return NO;
    }
    if ([edtCidade.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo cidade"];
        return NO;
    }
    if ([edtUF.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo UF"];
        return NO;
    }
    
    return YES;
}

-(void) alterarParticipante{
    participante.cpf = edtCPF.text;
    participante.senha = edtSenha.text;
    participante.nome = edtNomeParticipante.text;
    participante.apelido = edtApelido.text;
    participante.email = edtEmail.text;
    participante.sexo = [NSNumber numberWithInt:0];
    participante.nascimento = edtDataNascimento.text;
    participante.celular = edtCelular.text;
    participante.fixo = edtTelFixo.text;
    participante.cep = edtCEP.text;
    participante.endereco = edtEndereco.text;
    participante.numero = edtNumero.text;
    participante.complemento = edtComplemento.text;
    participante.bairro = edtBairro.text;
    participante.cidade = edtCidade.text;
    participante.uf = edtUF.text;
}




- (IBAction)btnInserirFotoClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar Foto" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:imagemCarregada ? @"Excluir foto" : nil otherButtonTitles:@"Escolher foto existente", @"Tirar Foto", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnSalvarClick:(id)sender {
    
    
    if ([self validouCampos]) {
        [ampulheta exibir];
        [self alterarParticipante];
        [participanteService alterarParticipante:participante];
    }

    
}

- (IBAction)btnCancelarClick:(id)sender {
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == edtCPF) {
        return [mascaraHelper mascarar:textField shouldChangeCharactersInRange:range replacementString:string mascara:MascaraHelper.MASCARA_CPF];
    }
    return YES;
}


#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if (imagemCarregada) {
                [imgParticipante setImage:nil];
                imagemCarregada = NO;
            } else {
                [self AbrirAlbum:picker];
            }
            break;
        case 1:
            imagemCarregada ? [self AbrirAlbum:picker] : [self AbrirCamera:picker];
            break;
        case 2:
            if (imagemCarregada) [self AbrirCamera:picker];
            break;
            
        default:
            break;
    }
}

-(void) AbrirCamera:(UIImagePickerController*) picker{
    @try
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        [[[UIAlertView alloc] initWithTitle:@"Sem Câmera" message:@"Câmera não disponível" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

-(void) AbrirAlbum:(UIImagePickerController*) picker{
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    imgParticipante.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imagemCarregada = YES;
}

#pragma mark - UIPickerViewDelegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return sexos[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([sexos[row] isEqualToString:@"Masculino"]) {
        participante.sexo = [NSNumber numberWithInt:0];
    } else {
        participante.sexo = [NSNumber numberWithInt:1];
    }
    edtSexo.text = sexos[row];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
}

- (void)nextDidTouchDown
{
    
    for (int i=0; i<[self.formItems count]; i++)
    {
        UITextField *field = [formItems objectAtIndex:i];
        if ([field isEditing] && i!=[self.formItems count]-1)
        {
            field = [formItems objectAtIndex:i+1];
            [field becomeFirstResponder];
            UIView *parentView = field.superview;
            CGFloat y = 120;
            if (parentView.tag == 89) {
                y = 340 + field.frame.origin.y;
            } else {
                y = 30 + field.frame.origin.y;
            }
            
            if (field.frame.origin.y + parentView.frame.origin.y > 140) {
                CGPoint ponto = CGPointMake(0, y);
                [scrollView setContentOffset:ponto animated:YES];
            }
            break;
        }
    }
}

- (void)doneDidTouchDown
{
    
    for (UITextField *field in self.formItems) {
        if ([field isEditing]) {
            [field resignFirstResponder];
            break;
        }
    }
}

- (void)previousDidTouchDown
{
    for (int i=0; i<[self.formItems count]; i++)
    {
        UITextField *field = [formItems objectAtIndex:i];
        if ([field isEditing] && i!=0)
        {
            
            field = [formItems objectAtIndex:i-1];
            [field becomeFirstResponder];
            break;
        }
    }
}

@end
