//
//  GrupoView.m
//  Vamu
//
//  Created by Guilherme Augusto on 25/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "GrupoView.h"
#import "GrupoViewCell.h"
#import "AppHelper.h"
#import "GrupoAtivo.h"
#import "Grupo.h"
#import "Participante.h"
#import "MotoristaAtivo.h"

@implementation GrupoView

@synthesize grupos, tabela;

-(id)iniciar{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GrupoView" owner:self options:nil];
    GrupoView *mainView = [subviewArray objectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Atualizar Grupos"
                                               object:nil];
    
    
    return mainView;
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"GrupoViewCell";
    
    GrupoViewCell *grupoCell = (GrupoViewCell*) [tabela dequeueReusableCellWithIdentifier:identifier];
    
    if (grupoCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        grupoCell = [nib objectAtIndex:0];
    }
    
    GrupoAtivo *grupoAtivo = [grupos objectAtIndex:indexPath.row];
    
    MotoristaAtivo *motorista = [self getMotorista:grupoAtivo];
    
    grupoCell.lblNomeGrupo.text = grupoAtivo.grupo.nome;
    grupoCell.lblQuantidade.text = [NSString stringWithFormat:@"%lu", (unsigned long)[grupoAtivo.motoristasAtivos count]];
    grupoCell.lblDistancia.text = [NSString stringWithFormat:@"%.2f Km, %.2f min", [motorista.distMetros floatValue] / 1000, [motorista.distSegundos floatValue] / 60];
    
    return grupoCell;
}

-(MotoristaAtivo*) getMotorista:(GrupoAtivo*) grupo{
    float distancia = 0;
    MotoristaAtivo *motoristaRetorno = [MotoristaAtivo new];
    for (MotoristaAtivo *motorista in grupo.motoristasAtivos) {
        if (distancia == 0) distancia = [motorista.distMetros floatValue];
        if ([motorista.distMetros floatValue] < distancia) {
            motoristaRetorno = [motorista copy];
            distancia = [motorista.distMetros floatValue];
        }
    }
    return motoristaRetorno;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [grupos count];
}

#pragma mark - Notification

- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Atualizar Grupos"]) {
        [self atualizarGrupos];
    }
}

-(void) atualizarGrupos{
    grupos = [AppHelper getGrupos];
    [tabela reloadData];
}

@end
