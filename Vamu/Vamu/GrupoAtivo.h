//
//  GrupoAtivo.h
//  Vamu
//
//  Created by Guilherme Augusto on 07/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Grupo, MotoristaAtivo;

@interface GrupoAtivo : Model

@property (nonatomic, retain) NSSet *motoristasAtivos;
@property (nonatomic, retain) Grupo *grupo;
@end

@interface GrupoAtivo (CoreDataGeneratedAccessors)

- (void)addMotoristasAtivosObject:(MotoristaAtivo *)value;
- (void)removeMotoristasAtivosObject:(MotoristaAtivo *)value;
- (void)addMotoristasAtivos:(NSSet *)values;
- (void)removeMotoristasAtivos:(NSSet *)values;

@end
