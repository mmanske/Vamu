//
//  SolicitarAdesaoCell.h
//  Vamu
//
//  Created by Guilherme Augusto on 05/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grupo.h"

@protocol SolicitarAdesaoCellDelegate <NSObject>

-(void) onSolicitouParticipacao:(Grupo*) grupo index:(int) index valor:(BOOL) valor;

@end

@interface SolicitarAdesaoCell : UITableViewCell{
    id <SolicitarAdesaoCellDelegate> delegate;
}

@property (nonatomic, strong) Grupo *grupo;
@property (strong, nonatomic) IBOutlet UILabel *lblNomeGrupo;
@property (strong, nonatomic) IBOutlet UISwitch *swtSolicitar;
@property (nonatomic) id delegate;
@property (nonatomic) int index;

- (IBAction)solicitouAdesao:(id)sender;

@end
