//
//  CadastroParticipanteViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 12/04/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CadastroParticipanteViewController.h"
#import "CSNotificationView.h"
#import "EXPhotoViewer.h"
#import "CustomActivityView.h"
#import "Validations.h"
#import "EnviarImagemService.h"
#import "AppHelper.h"
#import "MascaraHelper.h"

@interface CadastroParticipanteViewController (){
    BOOL imagemCarregada;
    Participante *participanteCriado;
    UIDatePicker *pickerNascimento;
    NSArray *sexos;
}

@property (nonatomic, strong) ParticipanteService *participanteService;
@property (nonatomic, strong) CustomActivityView *ampulheta;
@property (nonatomic, strong) UIPickerView *pickerSexo;
@property (nonatomic, strong) EnviarImagemService *enviarImagemService;
@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;
@property (nonatomic) NSMutableArray *formItems;
@property (strong, nonatomic) MascaraHelper *mascaraHelper;

@end

@implementation CadastroParticipanteViewController


@synthesize scrollView;
@synthesize imgBackGround;
@synthesize edtApelido, edtBairro, edtCelular, edtCEP, edtCidade, edtComplemento, edtConfirmarSenha, edtCPF;
@synthesize edtEmail, edtEndereco, edtNascimento, edtNome, edtNumero, edtSenha, edtSexo, edtUF;
@synthesize foto, formItems;
@synthesize participanteService, enhancedKeyboard;
@synthesize ampulheta, pickerSexo, cpf, senha, enviarImagemService, mascaraHelper;

-(void) dadosTeste{
    edtApelido.text = @"Guil";
    edtBairro.text = @"Padre Miguel";
    edtCelular.text = @"21983090611";
    edtCEP.text = @"21775530";
    edtCidade.text = @"Rio de Janeiro";
    edtComplemento.text = @"Fundos";
    edtConfirmarSenha.text = @"123";
    edtCPF.text = @"40388201819";
    edtEmail.text = @"gassis1000@gmail.com";
    edtEndereco.text = @"Trav. Francisco Ferreira";
    edtNascimento.text = @"18/10/1991";
    edtNome.text = @"Guilherme Augusto Barreto de Assis";
    edtNumero.text = @"6";
    edtSenha.text = @"123";
    edtSexo.text = @"Masculino";
    edtUF.text = @"RJ";
}

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
    
    self.exibirNavigationBar = YES;
    
    self.enhancedKeyboard = [KSEnhancedKeyboard new];
    self.enhancedKeyboard.delegate = self;
    
    sexos = @[@"Masculino", @"Feminino"];
    
    pickerNascimento = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 230, 0)];
    pickerNascimento.datePickerMode = UIDatePickerModeDate;
    [pickerNascimento addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventValueChanged];
    
    edtNascimento.inputView = pickerNascimento;
    
    pickerSexo = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 230, 0)];
    pickerSexo.delegate = self;
    pickerSexo.dataSource = self;
    
    edtSexo.inputView = pickerSexo;
    
    scrollView.contentSize=CGSizeMake(320,1020);
    [imgBackGround sizeToFit];
    
    if (cpf.length > 0) {
        edtCPF.text = cpf;
    }
    
    if (senha.length > 0) {
        edtSenha.text = senha;
    }
    
    edtSexo.text = @"Masculino";
    
    foto.layer.cornerRadius = foto.bounds.size.width/2;
    foto.layer.masksToBounds = YES;
    foto.layer.borderWidth = 2;
    foto.layer.borderColor = [UIColor whiteColor].CGColor;
    foto.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    edtApelido.delegate = edtBairro.delegate = edtCelular.delegate = edtCEP.delegate = edtCidade.delegate = edtComplemento.delegate = edtConfirmarSenha.delegate = edtCPF.delegate = edtEmail.delegate = edtEndereco.delegate = edtNascimento.delegate = edtNome.delegate = edtNumero.delegate = edtSenha.delegate = edtSexo.delegate = edtUF.delegate = self;
    
//    [self dadosTeste];
    
    participanteCriado = [Participante new];

    participanteService = [ParticipanteService new];
    participanteService.delegate = self;
    
    enviarImagemService = [EnviarImagemService new];
    enviarImagemService.delegate = self;
    
    ampulheta = [CustomActivityView new];
    
    [self placeHolderTextField];
    mascaraHelper = [MascaraHelper new];
    
    // Create the picture bucket.
//    S3CreateBucketRequest *createBucketRequest = [[S3CreateBucketRequest alloc] initWithName:@"vamu" andRegion:[S3Region SASaoPaulo]];
//    S3CreateBucketResponse *createBucketResponse = [self.s3 createBucket:createBucketRequest];
//    if(createBucketResponse.error != nil)
//    {
//        NSLog(@"Error: %@", createBucketResponse.error);
//    }
}

-(void) placeHolderTextField{
    edtApelido.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtApelido.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtBairro.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtBairro.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtCelular.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtCelular.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtCEP.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtCEP.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtCidade.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtCidade.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtComplemento.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtComplemento.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtConfirmarSenha.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtConfirmarSenha.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtCPF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtCPF.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtEmail.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtEndereco.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtEndereco.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtNascimento.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtNascimento.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtNome.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtNome.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtNumero.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtNumero.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtSenha.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtSenha.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtSexo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtSexo.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtUF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtUF.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sgCadVeiculo"]) {
        CadastroVeiculoViewController *view = segue.destinationViewController;
        [view setProprietario:participanteCriado];
    }
}

- (IBAction)btnSalvarClick:(id)sender {
//    [self performSegueWithIdentifier:@"sgCadVeiculo" sender:self];
    if ([self validouCampos]) {
        [ampulheta exibir];
        [self criarParticipante];
        [participanteService cadastrarParticipante:participanteCriado];
    }
}

- (IBAction)btnCancelarClick:(id)sender {
}

- (IBAction)btnInserirFotoClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar Foto" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:imagemCarregada ? @"Excluir foto" : nil otherButtonTitles:@"Escolher foto existente", @"Tirar Foto", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if (imagemCarregada) {
                [foto setImage:nil];
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
    if ([edtCPF.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Cadastrar foto" message:@"Para cadastrar a Foto, informe o CPF primeiro!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
        
    }

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
    if ([edtCPF.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Cadastrar foto" message:@"Para cadastrar a Foto, informe o CPF primeiro!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
        
    }

    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    foto.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imagemCarregada = YES;
    

    
}

#pragma mark - Métodos

-(void) getDate:(UIDatePicker *) sender{
    NSDate *currentDate = sender.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    edtNascimento.text = [formatter stringFromDate:currentDate];
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
    if ([edtNome.text isEqualToString:@""]) {
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
    if ([edtNascimento.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo nascimento"];
        return NO;
    }
    if ([edtCelular.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo celular"];
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

-(void) criarParticipante{
    participanteCriado.cpf = edtCPF.text;
    participanteCriado.senha = edtSenha.text;
    participanteCriado.nome = edtNome.text;
    participanteCriado.apelido = edtApelido.text;
    participanteCriado.email = edtEmail.text;
    participanteCriado.sexo = [NSNumber numberWithInt:0];
    participanteCriado.nascimento = edtNascimento.text;
    participanteCriado.celular = edtCelular.text;
    participanteCriado.cep = edtCEP.text;
    participanteCriado.endereco = edtEndereco.text;
    participanteCriado.numero = edtNumero.text;
    participanteCriado.complemento = edtComplemento.text;
    participanteCriado.bairro = edtBairro.text;
    participanteCriado.cidade = edtCidade.text;
    participanteCriado.uf = edtUF.text;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"sgCadVeiculo" sender:self];
    }
}

#pragma mark - ParticipanteServiceDelegate 

-(void)onOcorreuTimeout:(NSString *)msg{
    [self mensagemDeErro:@"Tempo limite esgotado"];
    participanteCriado = nil;
}

-(void)participanteCadastradoComSucesso:(NSString *)codParticipante{
    participanteCriado.codParticipante = codParticipante;
    
    
    if (foto.image) {
        
        NSString *nomeArquivo = [NSString stringWithFormat:@"%@.jpg", participanteCriado.cpf];
        NSString* absoluteFileName = [AppHelper getAbsolutePathForImageFile:nomeArquivo];
        
        NSData *imageToSave = UIImageJPEGRepresentation(foto.image, 0.2);
        [imageToSave writeToFile:absoluteFileName atomically:YES];
        
        [enviarImagemService enviarImagemDePessoa:edtCPF.text imagem:imageToSave];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [ampulheta esconder];
        [[[UIAlertView alloc] initWithTitle:nil message:@"Cadastro realizado com sucesso" delegate:self cancelButtonTitle:@"Inserir Veículo" otherButtonTitles: nil] show];

    }

}

-(void)participanteEnviaMensagemErro:(NSString *)mensagem{
    [self mensagemDeErro:mensagem];
}

-(void)participanteNaoValidouApelido:(NSString *)mensagem{
    [self mensagemDeErro:mensagem];
}

-(void)participanteNaoValidouCPF:(NSString *)mensagem{
    [self mensagemDeErro:mensagem];
}

-(void)participanteNaoValidouEmail:(NSString *)mensagem{
    [self mensagemDeErro:mensagem];
}

-(void) mensagemDeErro:(NSString*) mensagem{
    [ampulheta esconder];
    [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:mensagem];
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
        participanteCriado.sexo = [NSNumber numberWithInt:0];
    } else {
        participanteCriado.sexo = [NSNumber numberWithInt:1];
    }
    edtSexo.text = sexos[row];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@"Selecionar Foto"];
}


-(void) finalizaEnviarImagem {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ampulheta esconder];
    //[[[UIAlertView alloc] initWithTitle:nil message:@"Imagem enviada com sucesso!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    [[[UIAlertView alloc] initWithTitle:nil message:@"Cadastro realizado com sucesso" delegate:self cancelButtonTitle:@"Inserir Veículo" otherButtonTitles: nil] show];

    
}

-(void) erroAoEnviarImagem {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:nil message:@"Erro ao Enviar a Foto.  " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField == edtCPF) {
        return [mascaraHelper mascarar:textField shouldChangeCharactersInRange:range replacementString:string mascara:MascaraHelper.MASCARA_CPF];
    }
    return YES;
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
                y = 300 + field.frame.origin.y;
            }
            
            if (field.frame.origin.y + parentView.frame.origin.y > 160) {
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
