

#import "DemoService.h"
#import "JSONObjects.h"

#import "Participante.h"
#import "Veiculo.h"

@interface DemoService()

-(void) carregarDadosDemo;
-(NSDictionary*) carregaDicFile:(NSString*) fileName;

@end

@implementation DemoService

-(NSDictionary*) carregaDicFile:(NSString*) fileName {
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
     NSError *error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSDictionary *dic = [content objectFromJSONString];
    return dic;
    
}

-(NSArray*) carregaArrayFile:(NSString*) fileName {
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSError *error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSArray *dic = [content objectFromJSONString];
    return dic;
    
}

-(void) carregarDadosDemo {
    
    [Participante truncateNoSave];
    [Veiculo truncateNoSave];
    
    NSError *error = nil;
    [Model saveAll:&error];
    
    NSDictionary *dicParticipantes = [self carregaDicFile:@"Participantes"];
    for (NSDictionary *dicParticipante in dicParticipantes) {
        Participante *participante = [Participante objectFromDictionary:dicParticipante];
#pragma unused(participante)
    }
    
    [Participante saveAll:nil];
    
    NSDictionary *dicVeiculos = [self carregaDicFile:@"Veiculos"];
    for (NSDictionary *dicVeiculo in dicVeiculos) {
        Veiculo *veiculo = [Veiculo objectFromDictionary:dicVeiculo];
        NSString *predicate = [NSString stringWithFormat:@"codParticipante = %@", [dicVeiculo objectForKey:@"codParticipante"]];
        Participante *part = [[Participante getWithPredicate:predicate] objectAtIndex:0];
        [part addCarroObject:veiculo];
    }
        
    [Model saveAll:&error];    
}

-(void) criarDadosDemonstracao {
    [self carregarDadosDemo];
    NSError *error = nil;
    [Model saveAll:&error];
    
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onDemoErro:)]) {
            [self.delegate onDemoErro: [error localizedDescription]];
        }
    } else {
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(onDemoSucesso)]) {
            [self.delegate onDemoSucesso];
        }
    }
    
}

@end
