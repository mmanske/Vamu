//
//  EditarVeiculoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 31/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "EditarVeiculoViewController.h"
#import "AppHelper.h"
#import "Veiculo.h"
#import "CustomActivityView.h"
#import "VeiculoService.h"
#import "CSNotificationView.h"
#import "EnviarImagemService.h"

@interface EditarVeiculoViewController (){
    BOOL imagemCarregada;
}

@property (nonatomic, strong) Veiculo *veiculo;
@property (nonatomic, strong) CustomActivityView *ampulheta;
@property (nonatomic, strong) VeiculoService *veiculoService;
@property (strong, nonatomic) SeguradoraService *seguradoraService;
@property (nonatomic, strong) UIPickerView *pickerSeguradora;
@property (strong, nonatomic) NSArray *seguradoras;
@property (nonatomic, strong) EnviarImagemService *enviarImagemService;
@property (nonatomic) NSMutableArray *formItems;
@property (strong, nonatomic) KSEnhancedKeyboard *enhancedKeyboard;


@end

@implementation EditarVeiculoViewController

@synthesize edtAno, edtCor, edtMarca, edtModelo, edtPlaca, edtRenavam, edtSegurador;
@synthesize imgCarro;
@synthesize veiculo;
@synthesize ampulheta;
@synthesize veiculoService, imgBackground, enviarImagemService, enhancedKeyboard, formItems;
@synthesize seguradoras, seguradoraService, pickerSeguradora, scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Editar Veículo";
    
    self.formItems = [NSMutableArray new];
    UIView *subView = [self.view viewWithTag:88];
    
    for (UIView *view in [subView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [formItems addObject:view];
        }
    }
    self.enhancedKeyboard = [KSEnhancedKeyboard new];
    self.enhancedKeyboard.delegate = self;
    
    
    veiculoService = [VeiculoService new];
    veiculoService.delegate = self;
    
    seguradoraService = [SeguradoraService new];
    seguradoraService.delegate = self;
    
    [ampulheta exibir];
    [seguradoraService buscarSeguradoras];
    
    pickerSeguradora = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 230, 0)];
    pickerSeguradora.delegate = self;
    pickerSeguradora.dataSource = self;
    edtSegurador.inputView = pickerSeguradora;
    
    scrollView.contentSize=CGSizeMake(320,570);
    [imgBackground sizeToFit];
    
    imgCarro.layer.cornerRadius = imgCarro.bounds.size.width/2;
    imgCarro.layer.masksToBounds = YES;
    imgCarro.layer.borderWidth = 2;
    imgCarro.layer.borderColor = [UIColor whiteColor].CGColor;
    imgCarro.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    ampulheta = [CustomActivityView new];
    
    edtAno.delegate = edtCor.delegate = edtMarca.delegate = edtModelo.delegate = edtPlaca.delegate = edtRenavam.delegate = edtSegurador.delegate = self;
    
    NSSet *carros = [AppHelper getParticipanteLogado].carro;
    if ([carros count] > 0) {
        for (Veiculo *carro in carros) {
            veiculo = carro;
            edtAno.text = veiculo.ano;
            edtCor.text = veiculo.cor;
            edtMarca.text = veiculo.marca;
            edtModelo.text = veiculo.modelo;
            edtPlaca.text = veiculo.placa;
            edtRenavam.text = veiculo.renavan;
            
            
            if (veiculo.seguradora) {
                NSString *filtro = [NSString stringWithFormat:@"codSeguradora = %@", veiculo.seg.codSeguradora];
                NSArray *segs = [Seguradora getWithPredicate:filtro];
                if ([segs count] > 0) {
                    Seguradora *seg = [segs objectAtIndex:0];
                    edtSegurador.text = seg.descricao;
                }
                
            }

            NSString *fileName = [NSString stringWithFormat:@"%@-%@.jpg", veiculo.participante.cpf,veiculo.placa];
            NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
            imgCarro.image = [UIImage imageWithContentsOfFile:imageFileName];
            break;
        }
    }
    
    enviarImagemService = [EnviarImagemService new];
    enviarImagemService.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnInserirFotoClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar Foto" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:imagemCarregada ? @"Excluir foto" : nil otherButtonTitles:@"Escolher foto existente", @"Tirar Foto", nil];
    
    [actionSheet showInView:self.view];
}

-(void) criarVeiculo{
    veiculo.ano = edtAno.text;
    veiculo.cor = edtCor.text;
//    veiculo.foto = UIImagePNGRepresentation(imgCarro.image);
    veiculo.marca = edtMarca.text;
    veiculo.modelo = edtModelo.text;
    veiculo.placa = edtPlaca.text;
    veiculo.renavan = edtRenavam.text;
    veiculo.seguradora = edtSegurador.text;
    veiculo.participante = [AppHelper getParticipanteLogado];
}

- (IBAction)btnCancelarClick:(id)sender {
}

- (IBAction)btnSalvarClick:(id)sender {
    if ([self validouCampos]) {
        [ampulheta exibir];
        [self criarVeiculo];
        [veiculoService editarVeiculo:veiculo];
        [self.navigationController.navigationController popViewControllerAnimated:YES];
    }
}

-(BOOL)validouCampos{
    
    if ([edtPlaca.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo placa"];
        return NO;
    }
    
    if ([edtRenavam.text isEqualToString:@""]) {
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
    
    if ([edtSegurador.text isEqualToString:@""]) {
        [CSNotificationView showInViewController:self.navigationController style:CSNotificationViewStyleError message:@"Preencha o campo seguradora"];
        return NO;
    }
    
    return YES;
}

#pragma mark - VeiculoServiceDelegate

-(void)veiculoCadastradoComSucesso{
    
    
    if (imgCarro.image) {
        Participante *participante = [AppHelper getParticipanteLogado];
        NSString *cpfLimpo = participante.cpf;
        [enviarImagemService enviarImagemDeCarro:cpfLimpo placa:veiculo.placa imagem:UIImageJPEGRepresentation(imgCarro.image, 0.2)];
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

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    imgCarro.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imagemCarregada = YES;
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
    veiculo.seg = seguradoras[row];
    edtSegurador.text = veiculo.seg.descricao;
}

-(void) finalizaEnviarImagem {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cadastro de veículo" message:@"Veículo atualizado com sucesso" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];

    
}

-(void) erroAoEnviarImagem {
    [ampulheta esconder];
    [[[UIAlertView alloc] initWithTitle:@"Cadastro de veículo" message:@"Erro ao Enviar a Foto" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
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

@end
