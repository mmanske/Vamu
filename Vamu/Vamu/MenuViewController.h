//
//  MenuViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 12/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "Participante.h"

@protocol MenuViewControllerDelegate <NSObject>

-(void) onSelecionouView:(BaseViewController*) viewSelecionada;

@end

@interface MenuViewController : BaseViewController{
    id <MenuViewControllerDelegate> delegate;
}

@property (strong, nonatomic) MKRoute *rota;
@property (nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imgParticipante;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeParticipante;
@property (strong, nonatomic) Participante *participanteLogado;

#pragma mark - Opções Menu
- (IBAction)meusDados:(id)sender;
- (IBAction)alterarSenha:(id)sender;
- (IBAction)editarVeiculo:(id)sender;
- (IBAction)editarGrupo:(id)sender;
- (IBAction)solicitarAdesao:(id)sender;
- (IBAction)cancelarParticipacao:(id)sender;
- (IBAction)aceitarParticipacao:(id)sender;
- (IBAction)enviarConvite:(id)sender;
- (IBAction)receberAviso:(id)sender;
- (IBAction)minhasViagens:(id)sender;
- (IBAction)sair:(id)sender;


@end
