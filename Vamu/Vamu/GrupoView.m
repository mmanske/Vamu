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
    
    grupoCell.lblNomeGrupo.text = grupoAtivo.grupo.nome;
    grupoCell.lblQuantidade.text = [NSString stringWithFormat:@"%lu", (unsigned long)[grupoAtivo.motoristasAtivos count]];
    
    return grupoCell;
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
