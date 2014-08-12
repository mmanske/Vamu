//
//  Grupo.h
//  Vamu
//
//  Created by Guilherme Augusto on 12/08/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Participante;

@interface Grupo : Model

@property (nonatomic, retain) NSNumber * ativarFiltros;
@property (nonatomic, retain) NSString * codGrupo;
@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * receberSolicitacao;
@property (nonatomic, retain) NSNumber * visivel;
@property (nonatomic, retain) NSNumber * solicitar;
@property (nonatomic, retain) Participante *moderador;
@property (nonatomic, retain) NSSet *participantes;
@end

@interface Grupo (CoreDataGeneratedAccessors)

- (void)addParticipantesObject:(Participante *)value;
- (void)removeParticipantesObject:(Participante *)value;
- (void)addParticipantes:(NSSet *)values;
- (void)removeParticipantes:(NSSet *)values;

@end
