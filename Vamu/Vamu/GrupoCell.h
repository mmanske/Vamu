//
//  GrupoCell.h
//  Vamu
//
//  Created by Guilherme Augusto on 20/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Grupo.h"

@protocol GrupoCellDelegate <NSObject>

-(void) grupoCellAtivouGrupo:(Grupo*) grupo;
-(void) grupoCellDesativouGrupo:(Grupo*) grupo;

@end

@interface GrupoCell : UITableViewCell{
    id <GrupoCellDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UILabel *lblNomeGrupo;
@property (strong, nonatomic) IBOutlet UISwitch *swtAtivo;
@property (strong, nonatomic) Grupo *grupoAtual;
@property (nonatomic) id delegate;

- (IBAction)trocouStatus:(id)sender;

@end
