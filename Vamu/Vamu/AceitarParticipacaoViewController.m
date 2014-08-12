//
//  AceitarParticipacaoViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 01/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "AceitarParticipacaoViewController.h"
#import "SolicitacaoAdesao.h"
#import "Participante.h"
#import "GrupoService.h"
#import "AppHelper.h"
#import "NotificacaoService.h"
#import "CustomActivityView.h"
#import "Veiculo.h"

@interface AceitarParticipacaoViewController ()

@property (nonatomic, strong) CustomActivityView *ampulheta;
@property (nonatomic, strong) NSMutableArray *solicitacoes;
@property (nonatomic, strong) SolicitacaoAdesao *solicitacao;
@property (nonatomic, strong) GrupoService *grupoService;
@property (nonatomic, strong) NotificacaoService *notificacaoService;

@end

@implementation AceitarParticipacaoViewController

@synthesize ampulheta;
@synthesize lblEstatisticasParticipante, lblNomeGrupo, lblNomeParticipante;
@synthesize imgParticipante;
@synthesize solicitacoes;
@synthesize solicitacao;
@synthesize grupoService;
@synthesize notificacaoService;
@synthesize imagemService;
@synthesize lblCarro;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Aceitar participação";
    [self limparTela];
    
    grupoService = [GrupoService new];
    grupoService.delegate = self;
    
    ampulheta = [CustomActivityView new];
    
    notificacaoService = [NotificacaoService new];
    notificacaoService.delegate = self;
    
    imagemService = [BaixarImagemService new];
    imagemService.delegate = self;
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 2;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    NSString *predicate = [NSString stringWithFormat:@"destinatario.codParticipante = %@", [AppHelper getParticipanteLogado].codParticipante];
    
    solicitacoes = [NSMutableArray arrayWithArray:[SolicitacaoAdesao getWithPredicate:predicate]];
    
    if ([solicitacoes count] > 0) {
        solicitacao = [solicitacoes objectAtIndex:0];
        lblNomeParticipante.text = solicitacao.remetente.nome;
        lblNomeGrupo.text = solicitacao.nomeGrupo;
        [imagemService baixarImagemDePessoa:solicitacao.remetente.cpf];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnRecusarClick:(id)sender {
    if (solicitacao.nomeGrupo.length > 0) {
        [notificacaoService confirmacaoLeitura:solicitacao.codNotificacao];
    }
}

- (IBAction)btnAceitarClick:(id)sender {
    if (solicitacao.nomeGrupo.length > 0) {
        [ampulheta exibir];
        [grupoService aceitarParticipacao:[NSString stringWithFormat:@"%@", solicitacao.codGrupo] codParticipante:solicitacao.remetente.codParticipante];
    }
}

-(void)limparTela{
    lblNomeParticipante.text = @"";
    lblNomeGrupo.text = @"";
    lblEstatisticasParticipante.text = @"";
    imgParticipante.image = nil;
}

#pragma mark - GrupoServiceDelegate

-(void)grupoParticipacaoConfirmada{
    [ampulheta esconder];
    [notificacaoService confirmacaoLeitura:solicitacao.codNotificacao];
}

#pragma mark - NotificacaoServiceDelegate

-(void)notificacaoesConfirmouLeitura{
    [self apagarSolicitacao];
    [self proximaSolicitacao];
}

-(void) apagarSolicitacao{
    NSString *predicateNotificacao = [NSString stringWithFormat:@"codigo = %@", solicitacao.codNotificacao];
    NSString *predicateSolicitacao = [NSString stringWithFormat:@"codNotificacao = %@", solicitacao.codNotificacao];
    [Notificacao deleteWithPredicate:predicateNotificacao];
    [SolicitacaoAdesao deleteWithPredicate:predicateSolicitacao];
    [solicitacao delete];
    [SolicitacaoAdesao saveAll:nil];
    [Notificacao saveAll:nil];
}

-(void) proximaSolicitacao{
    [self limparTela];
    
    NSString *predicate = [NSString stringWithFormat:@"destinatario.codParticipante = %@", [AppHelper getParticipanteLogado].codParticipante];
    
    solicitacoes = [NSMutableArray arrayWithArray:[SolicitacaoAdesao getWithPredicate:predicate]];
    
    if ([solicitacoes count] > 0) {
        solicitacao = [solicitacoes objectAtIndex:0];
        lblNomeParticipante.text = solicitacao.remetente.nome;
        lblNomeGrupo.text = solicitacao.nomeGrupo;
        lblEstatisticasParticipante.text = [NSString stringWithFormat:@"%@ viagem(ns) desde %@", solicitacao.viagens, solicitacao.dataCadastro];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", solicitacao.remetente.cpf];
        NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
        
        imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];
    } else {
        solicitacao = nil;
    }
}

#pragma mark - ImagemServiceDelegate

-(void)finalizaBaixarImagem{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", solicitacao.remetente.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    self.imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];
}

@end
