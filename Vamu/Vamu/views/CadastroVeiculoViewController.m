//
//  CadastroVeiculoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 17/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "CadastroVeiculoViewController.h"
#import "EXPhotoViewer.h"
#import "LoginViewController.h"
#import "EnviarImagemService.h"
#import "AppHelper.h"
#import "MascaraHelper.h"


@interface CadastroVeiculoViewController (){
    Veiculo *veiculoParticipante;
}

@property (strong, nonatomic) VeiculoService *veiculoService;
@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) SeguradoraService *seguradoraService;
@property (nonatomic, strong) UIPickerView *pickerSeguradora;
@property (strong, nonatomic) NSArray *seguradoras;
@property (nonatomic) NSMutableArray *formItems;
@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;
@property (nonatomic, strong) EnviarImagemService *enviarImagemService;
@property (strong, nonatomic) MascaraHelper *mascaraHelper;
@end

@implementation CadastroVeiculoViewController

@synthesize seguradoraService;
@synthesize edtAno;
@synthesize edtCor;
@synthesize edtMarca;
@synthesize edtModelo;
@synthesize edtPlaca;
@synthesize edtRenavan;
@synthesize edtSeguradora;
@synthesize imgCarro;
@synthesize imagemCarregada;
@synthesize proprietario;
@synthesize veiculoService;
@synthesize ampulheta;
@synthesize scrollView;
@synthesize imgBackground;
@synthesize pickerSeguradora, mascaraHelper;
@synthesize seguradoras, enhancedKeyboard, formItems, enviarImagemService;

-(void)dadosTeste{
    edtAno.text = @"2010";
    edtCor.text = @"preto";
    edtMarca.text = @"Fiat";
    edtModelo.text = @"Palio";
    edtPlaca.text = @"abc-1234";
    edtRenavan.text = @"0987654";
    edtSeguradora.text = @"Porto Seguro";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Cadastro de veículo";
    self.exibirNavigationBar = YES;
    
    self.formItems = [NSMutableArray new];
    UIView *subView = [self.view viewWithTag:88];
    
    for (UIView *view in [subView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [formItems addObject:view];
        }
    }
    self.enhancedKeyboard = [KSEnhancedKeyboard new];
    self.enhancedKeyboard.delegate = self;

    
    seguradoraService = [SeguradoraService new];
    seguradoraService.delegate = self;
    
    [ampulheta exibir];
    [seguradoraService buscarSeguradoras];
    
    pickerSeguradora = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 230, 0)];
    pickerSeguradora.delegate = self;
    pickerSeguradora.dataSource = self;
    edtSeguradora.inputView = pickerSeguradora;
    
    self.navigationController.navigationBarHidden = NO;
    
    imgCarro.layer.cornerRadius = imgCarro.bounds.size.width/2;
    imgCarro.layer.masksToBounds = YES;
    imgCarro.layer.borderWidth = 2;
    imgCarro.layer.borderColor = [UIColor whiteColor].CGColor;
    imgCarro.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    edtAno.delegate = edtCor.delegate = edtMarca.delegate = edtModelo.delegate = edtPlaca.delegate = edtRenavan.delegate = edtSeguradora.delegate = self;
    
    scrollView.contentSize=CGSizeMake(320,570);
    [imgBackground sizeToFit];
    
//    [self dadosTeste];
    
    veiculoParticipante = [Veiculo new];
    
    veiculoService = [VeiculoService new];
    veiculoService.delegate = self;
    
    enviarImagemService = [EnviarImagemService new];
    enviarImagemService.delegate = self;

    
    ampulheta = [CustomActivityView new];
    
    [self placeHolderTextField];
    mascaraHelper = [MascaraHelper new];
    
}

-(void) placeHolderTextField{
    edtAno.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtAno.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtCor.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtCor.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtMarca.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtMarca.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtModelo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtModelo.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtPlaca.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtPlaca.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtRenavan.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtRenavan.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    edtSeguradora.attributedPlaceholder = [[NSAttributedString alloc] initWithString:edtSeguradora.placeholder attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAdicionarFotoClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar Foto" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:imagemCarregada ? @"Excluir foto" : nil otherButtonTitles:@"Escolher foto existente", @"Tirar Foto", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnSalvarClick:(id)sender {
    if ([self validouCampos]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [ampulheta exibir];
        [self criarVeiculo];
        [veiculoService cadastrarVeiculo:veiculoParticipante];
        [self.navigationController.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnCancelarClick:(id)sender {
    if ([self possuiVeiculoCadastrado]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Cadastro de Veículo" message:@"Sua participação ficará pendente até a inserção de pelo menos 1 veículo \n Deseja mesmo sair?" delegate:self cancelButtonTitle:@"Sim" otherButtonTitles:@"Não", nil] show];
    }
}

- (IBAction)clicouTela:(id)sender {
    [edtAno resignFirstResponder];
    [edtCor resignFirstResponder];
    [edtMarca resignFirstResponder];
    [edtModelo resignFirstResponder];
    [edtPlaca resignFirstResponder];
    [edtRenavan resignFirstResponder];
    [edtSeguradora resignFirstResponder];
}


- (IBAction)VERFOTO:(id)sender {
    [EXPhotoViewer showImageFrom:imgCarro];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if (imagemCarregada) {
                [imgCarro setImage:nil];
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
    imgCarro.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imagemCarregada = YES;
    
//    if (imgCarro.image) {
//        [enviarImagemService enviarImagemDePessoa:proprietario.cpf imagem:UIImageJPEGRepresentation(imgCarro.image, 1.0)];
//    }

    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == edtPlaca) {
        return [mascaraHelper mascarar:textField shouldChangeCharactersInRange:range replacementString:string mascara:MascaraHelper.MASCARA_PLACA];
    }
    return YES;
}


#pragma mark - BaseTab

-(BOOL)validouCampos{
    
    if ([edtPlaca.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo placa"];
        return NO;
    }
    
    if ([edtRenavan.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo renavan"];
        return NO;
    }
    
    if ([edtMarca.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo marca"];
        return NO;
    }
    
    if ([edtModelo.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo modelo"];
        return NO;
    }
    
    if ([edtCor.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo cor"];
        return NO;
    }
    
    if ([edtAno.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo ano"];
        return NO;
    }
    
    if ([edtSeguradora.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo seguradora"];
        return NO;
    }
    
    return YES;
}

-(void) criarVeiculo{
    veiculoParticipante.ano = edtAno.text;
    veiculoParticipante.cor = edtCor.text;
//    veiculoParticipante.foto = UIImageJPEGRepresentation(imgCarro.image, 0.1);
    veiculoParticipante.marca = edtMarca.text;
    veiculoParticipante.modelo = edtModelo.text;
    veiculoParticipante.placa = edtPlaca.text;
    veiculoParticipante.renavan = edtRenavan.text;
    veiculoParticipante.seguradora = edtSeguradora.text;
    veiculoParticipante.participante = proprietario;
}

-(void) limparCampos{
    edtAno.text = @"";
    edtCor.text = @"";
    edtMarca.text = @"";
    edtModelo.text = @"";
    edtPlaca.text = @"";
    edtRenavan.text = @"";
    edtSeguradora.text = @"";
    imgCarro.image = nil;
}

-(BOOL) possuiVeiculoCadastrado{
    NSString *predicateCarros = [NSString stringWithFormat:@"participante.cpf = '%@'", proprietario.cpf];
    NSArray *veiculos = [Veiculo getWithPredicate:predicateCarros];
    return [veiculos count] > 0 ? YES : NO;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self limparCampos];
    veiculoParticipante = nil;
    if (buttonIndex == 1) {
        veiculoParticipante = [Veiculo new];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - VeiculoServiceDelegate

-(void)veiculoCadastradoComSucesso{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    [ampulheta esconder];
  //  [[[UIAlertView alloc] initWithTitle:@"Cadastro de veículo" message:@"Veículo cadastrado com sucesso" delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles:@"Novo veículo", nil] show];
    
    
    
    if (imgCarro.image) {
        NSString *cpfLimpo = [AppHelper limparCPF:proprietario.cpf];
  //      [ampulheta exibir];
        [enviarImagemService enviarImagemDeCarro:cpfLimpo placa:veiculoParticipante.placa imagem:UIImageJPEGRepresentation(imgCarro.image, 0.2)];
    } else {
        [self finalizaEnviarImagem];
    }
    
    
}

-(void)veiculoEnviaMensagemErro:(NSString *)mensagem{
    [self mensagemDeErro:mensagem];
}

-(void)veiculoNaoValidouPlaca:(NSString *)mensagem{
    [self mensagemDeErro:mensagem];
}

-(void)veiculoNaoValidouRenavan:(NSString *)mensagem{
    [self mensagemDeErro:mensagem];
}

-(void)onOcorreuTimeout:(NSString *)msg{
    [self mensagemDeErro:@"Tempo limite esgotado"];
}

-(void) mensagemDeErro:(NSString*) mensagem{
    [ampulheta esconder];
    [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:mensagem];
}

#pragma mark - Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@"Selecionar Foto"];
}

#pragma mark - SeguradoraDelegate

-(void)retornouSeguradoras{
    [ampulheta esconder];
    seguradoras = [Seguradora getAll];
}

-(void)erroAoBuscarSeguradoras{
    [ampulheta esconder];
}

#pragma mark - UIPickerView

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [seguradoras count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Seguradora *seg = [seguradoras objectAtIndex:row];
    return seg.descricao;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    veiculoParticipante.seg = seguradoras[row];
    edtSeguradora.text = veiculoParticipante.seg.descricao;
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
            if (i >= 3) {
                CGFloat y = 40;
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

-(void) finalizaEnviarImagem {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cadastro de veículo" message:@"Veículo cadastrado com sucesso. Deseja cadastrar outro?" delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles:@"Cadastrar", nil] show];
    
}

-(void) erroAoEnviarImagem {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:nil message:@"Erro ao Enviar a Foto. Você pode tentar enviar novamente, entrando na opção de Meus Dados. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
}
@end
