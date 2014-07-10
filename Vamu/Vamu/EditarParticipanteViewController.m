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

@interface EditarParticipanteViewController (){
    BOOL imagemCarregada;
    UIDatePicker *pickerNascimento;
    UIPickerView *pickerSexo;
    NSArray *sexos;
}

@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) ParticipanteService *participanteService;
@property (nonatomic, strong) Participante *participante;

@end

@implementation EditarParticipanteViewController

@synthesize participante;
@synthesize edtApelido, edtBairro, edtCelular, edtCEP, edtCidade, edtComplemento, edtConfirmarSenha, edtCPF, edtDataNascimento, edtEmail, edtEndereco, edtNomeParticipante, edtNumero, edtSenha, edtSexo, edtTelFixo, edtUF;
@synthesize scrollView;
@synthesize imgBg, imgParticipante;
@synthesize ampulheta;
@synthesize participanteService;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (IBAction)btnInserirFotoClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Adicionar Foto" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:imagemCarregada ? @"Excluir foto" : nil otherButtonTitles:@"Escolher foto existente", @"Tirar Foto", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)btnSalvarClick:(id)sender {
}

- (IBAction)btnCancelarClick:(id)sender {
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

@end
