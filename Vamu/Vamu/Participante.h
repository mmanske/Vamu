//
//  Participante.h
//  Vamu
//
//  Created by Guilherme Augusto on 01/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@class TrajetoFavorito, Veiculo;

@interface Participante : Model

@property (nonatomic, retain) NSString * apelido;
@property (nonatomic, retain) NSString * bairro;
@property (nonatomic, retain) NSString * celular;
@property (nonatomic, retain) NSString * cep;
@property (nonatomic, retain) NSString * cidade;
@property (nonatomic, retain) NSString * codParticipante;
@property (nonatomic, retain) NSString * complemento;
@property (nonatomic, retain) NSString * cpf;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * endereco;
@property (nonatomic, retain) NSString * fixo;
@property (nonatomic, retain) NSNumber * motorista;
@property (nonatomic, retain) NSString * nascimento;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * numero;
@property (nonatomic, retain) NSString * senha;
@property (nonatomic, retain) NSNumber * sexo;
@property (nonatomic, retain) NSString * uf;
@property (nonatomic, retain) NSNumber * viajensCarona;
@property (nonatomic, retain) NSNumber * viajensMotorista;
@property (nonatomic, retain) NSNumber * latitudeAtual;
@property (nonatomic, retain) NSNumber * longitudeAtual;
@property (nonatomic, retain) NSNumber * latitudeFinal;
@property (nonatomic, retain) NSNumber * longitudeFinal;
@property (nonatomic, retain) NSSet *carro;
@property (nonatomic, retain) NSSet *trajetosFavoritos;
@end

@interface Participante (CoreDataGeneratedAccessors)

- (void)addCarroObject:(Veiculo *)value;
- (void)removeCarroObject:(Veiculo *)value;
- (void)addCarro:(NSSet *)values;
- (void)removeCarro:(NSSet *)values;

- (void)addTrajetosFavoritosObject:(TrajetoFavorito *)value;
- (void)removeTrajetosFavoritosObject:(TrajetoFavorito *)value;
- (void)addTrajetosFavoritos:(NSSet *)values;
- (void)removeTrajetosFavoritos:(NSSet *)values;

@end
