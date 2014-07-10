//
//  MainVC.m
//  Vamu
//
//  Created by Guilherme Augusto on 10/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "MainVC.h"
#import "NotificacaoService.h"
#import "AppHelper.h"
#import "SolicitacaoAdesao.h"
#import "SolicitacaoCarona.h"
#import "AceitacaoCarona.h"

@interface MainVC ()

@property (nonatomic, strong) NotificacaoService *notificacaoService;
@property (nonatomic, strong) NSTimer *timerNotificacao;
@property (nonatomic, strong) NSMutableArray *listaGrupos;
@property (nonatomic, strong) NSMutableArray *listaMapas;

@end

@implementation MainVC

@synthesize notificacaoService;
@synthesize timerNotificacao;
@synthesize listaGrupos;
@synthesize listaMapas;

-(void) consultarNotificacoes:(NSTimer*) timer{
    [notificacaoService notificacaoParaParticipante:[AppHelper getParticipanteLogado]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    notificacaoService = [NotificacaoService new];
    notificacaoService.delegate = self;
    
    NSDate *d = [NSDate dateWithTimeIntervalSinceNow:1];
    timerNotificacao = [[NSTimer alloc] initWithFireDate: d
                                          interval:30
                                            target:self
                                          selector:@selector(consultarNotificacoes:)
                                          userInfo:nil repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timerNotificacao forMode: NSDefaultRunLoopMode];
    
    listaGrupos = [NSMutableArray new];
    listaMapas  = [NSMutableArray new];
    
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 1:
            identifier = @"sgDefinirTrajeto";
            break;
        case 2:
            identifier = @"sgMapa";
            break;
        case 3:
            identifier = @"sgEditarParticipante";
            break;
        case 4:
            identifier = @"sgEditarVeiculo";
            break;
        case 5:
            identifier = @"sgCadastroGrupo";
            break;
        case 6:
            identifier = @"sgSolicitarAdesao";
            break;
        case 7:
            identifier = @"sgCancelarParticipacao";
            break;
        case 8:
            identifier = @"sgAceitarParticipacao";
            break;
        case 9:
            identifier = @"sgEnviarConvite";
            break;
        case 10:
            identifier = @"sgReceberAviso";
            break;
    }
    
    return identifier;
}

- (NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 0:
            identifier = @"row2";
            break;
        case 1:
            identifier = @"row1";
            break;
        case 2:
            identifier = @"row2";
            break;
        case 3:
            identifier = @"row3";
            break;
        case 4:
            identifier = @"row4";
            break;
        case 5:
            identifier = @"row5";
            break;
        case 6:
            identifier = @"row6";
            break;
        case 7:
            identifier = @"row7";
            break;
        case 8:
            identifier = @"row8";
            break;
        case 9:
            identifier = @"row9";
            break;
    }
    
    return identifier;
}


- (CGFloat)leftMenuWidth
{
    return 300;
}

- (CGFloat)rightMenuWidth
{
    return 180;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
}

- (void)configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
}

- (void) configureSlideLayer:(CALayer *)layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
}

- (AMPrimaryMenu)primaryMenu
{
    return AMPrimaryMenuLeft;
}


// Enabling Deepnes on left menu
- (BOOL)deepnessForLeftMenu
{
    return YES;
}

// Enabling Deepnes on left menu
- (BOOL)deepnessForRightMenu
{
    return YES;
}

// Enabling darkness while left menu is opening
- (CGFloat)maxDarknessWhileLeftMenu
{
    return 0.5;
}

// Enabling darkness while right menu is opening
- (CGFloat)maxDarknessWhileRightMenu
{
    return 0.5;
}

-(NSIndexPath *)initialIndexPathForLeftMenu{
    NSUInteger indexes[] = {0, 1};
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:2];
    return indexPath;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - NotificacaoServiceDelegate

-(void)notificacaoesRecebidas:(NSMutableArray *)notificacoes grupos:(NSMutableArray *)grupos motoristas:(NSMutableArray *)motoristas{
    
    [AppHelper setMotoristas:motoristas];
    [AppHelper setGrupos:grupos];
    
    NSMutableArray *solicitacoes = [NSMutableArray new];
    NSMutableArray *aceitacoes = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Atualizar Mapa" object:self];
    
    for (Notificacao *notificacao in notificacoes) {
        if ([notificacao.tipo isEqualToNumber:[NSNumber numberWithInt:2]]) {
            SolicitacaoAdesao *solicitacao = [SolicitacaoAdesao new];
            
            solicitacao.codGrupo = notificacao.codGrupo;
            solicitacao.nomeGrupo = notificacao.nomeGrupo;
            solicitacao.codNotificacao = notificacao.codigo;
            solicitacao.recebida = [NSNumber numberWithBool:NO];
            solicitacao.remetente = notificacao.solicitante;
            solicitacao.viagens = notificacao.viagens;
            solicitacao.dataCadastro = notificacao.dataCadastro;
            solicitacao.destinatario = notificacao.destinatario;
            
            [solicitacao save:nil];
        }
        
        if ([notificacao.tipo isEqualToNumber:[NSNumber numberWithInt:4]]) {
            SolicitacaoCarona *solicitacao = [SolicitacaoCarona new];
            
            solicitacao.codgrupo = notificacao.codGrupo;
            solicitacao.codNotificacao = notificacao.codigo;
            solicitacao.recebida = [NSNumber numberWithBool:NO];
            solicitacao.remetente = notificacao.solicitante;
            solicitacao.numViagens = notificacao.viagens;
            solicitacao.destinatario = notificacao.destinatario;
            solicitacao.nomeDestino = notificacao.nomeDestino;
            
            [solicitacoes addObject:solicitacao];
            
            [solicitacao save:nil];
        }
        
        if ([notificacao.tipo isEqualToNumber:[NSNumber numberWithInt:6]]) {
            AceitacaoCarona *solicitacao = [AceitacaoCarona new];
            
            solicitacao.codNotificacao = notificacao.codigo;
            solicitacao.remetente = notificacao.solicitante;
            solicitacao.destinatario = notificacao.destinatario;
            solicitacao.codViagem = notificacao.mensagem;
            
            [aceitacoes addObject:solicitacao];
            
            [solicitacao save:nil];
        }
    }
    
    [AppHelper setSolicitacoes:solicitacoes];
    [AppHelper setAceitacoes:aceitacoes];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Solicitacao Recebida" object:self];
}

@end
