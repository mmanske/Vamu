//
//  Rota.h
//  Vamu
//
//  Created by Guilherme Augusto on 24/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class Ponto;

@interface Rota : Model

@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSSet *pontos;
@end

@interface Rota (CoreDataGeneratedAccessors)

- (void)addPontosObject:(Ponto *)value;
- (void)removePontosObject:(Ponto *)value;
- (void)addPontos:(NSSet *)values;
- (void)removePontos:(NSSet *)values;

@end
