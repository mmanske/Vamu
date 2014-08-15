//
//  EnviarConviteViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 16/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "EnviarConviteViewController.h"
#import "CustomActivityView.h"
#import "SolicitarAdesaoCell.h"

@interface EnviarConviteViewController ()

@property (strong, nonatomic) NSMutableArray *grupos;
@property (strong, nonatomic) CustomActivityView *ampulheta;
@property (strong, nonatomic) GrupoService *grupoService;
@property (strong, nonatomic) NSMutableArray *gruposSolicitados;

@end

@implementation EnviarConviteViewController

@synthesize edtEmail, tabela, grupos = _grupos, ampulheta, grupoService, gruposSolicitados;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ampulheta = [CustomActivityView new];
    
    gruposSolicitados = [NSMutableArray new];
    
    grupoService = [GrupoService new];
    grupoService.delegate = self;
    
    edtEmail.delegate = self;
    
    tabela.delegate = self;
    tabela.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [ampulheta exibir];
    [grupoService consultarGrupoPorPessoa];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnCancelarClick:(id)sender {
}

- (IBAction)btnEnviarClick:(id)sender {
    if (edtEmail.text.length <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"Enviar Convite" message:@"Informe o e-mail do destinatário" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    [ampulheta exibir];
    for (Grupo *grupo in _grupos) {
        if ([grupo.solicitar boolValue]) {
            [grupoService enviarConvite:grupo.codGrupo email:edtEmail.text];
        }
    }
    [ampulheta esconder];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_grupos count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *adesaoCell = @"SolicitarAdesaoCell";
    
    SolicitarAdesaoCell *cell = (SolicitarAdesaoCell *)[tabela dequeueReusableCellWithIdentifier:adesaoCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:adesaoCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Grupo *grupo = [_grupos objectAtIndex:indexPath.row];
    
    cell.lblNomeGrupo.text = grupo.nome;
    cell.swtSolicitar.on = [grupo.solicitar boolValue];
    cell.grupo = grupo;
    cell.delegate = self;
    cell.index = indexPath.row;
    
    return cell;
}

#pragma mark - GrupoServiceDelegate

-(void)grupoConsultaNomeRetorno:(NSMutableArray *)grupos{
    [ampulheta esconder];
    _grupos = grupos;
    [tabela reloadData];
}

-(void)grupoSolicitacaoEnviada{
    [[[UIAlertView alloc] initWithTitle:@"Enviar Convite" message:@"Convite de participação enviado" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

-(void)onSolicitouParticipacao:(Grupo *)grupo index:(int)index valor:(BOOL)valor{
    Grupo *grup = [_grupos objectAtIndex:index];
    grup.solicitar = [NSNumber numberWithBool:valor];
}

#pragma mark - TextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == edtEmail) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y - 140.0), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == edtEmail) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y + 140.0), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [edtEmail resignFirstResponder];
}

@end
