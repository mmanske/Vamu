//
//  GrupoView.h
//  Vamu
//
//  Created by Guilherme Augusto on 25/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrupoView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *grupos;
@property (weak, nonatomic) IBOutlet UITableView *tabela;

-(id) iniciar;
-(void) atualizarGrupos;

@end
