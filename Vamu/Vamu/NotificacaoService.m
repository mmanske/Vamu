
//
//  NotificacaoService.m
//  Vamu
//
//  Created by Guilherme Augusto on 01/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "NotificacaoService.h"
#import "Veiculo.h"
#import "AppHelper.h"
#import "MotoristaAtivo.h"
#import "GrupoAtivo.h"
#import "Rota.h"
#import "Ponto.h"
#import "Grupo.h"

@implementation NotificacaoService

-(void)confirmacaoLeitura:(NSNumber *)codNotificacao{
    NSString *strURL = [self confereURLConexao:@"notificacao/lido"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", strURL, codNotificacao];
    
    [self consultarUrl:url timeOut:30];
}

-(void)notificacaoParaParticipante:(Participante *)participante{
    NSString *strURL = [self confereURLConexao:@"atualizacao/carregar"];
    if (strURL == nil) {
        return;
    }
    
    NSString *tipoParticipante = [participante.motorista isEqualToNumber:[NSNumber numberWithBool:YES]] ? @"1" : @"2";
    
    if (![participante.latitudeAtual isEqual:nil] && ![participante.longitudeAtual isEqual:nil]) {
        
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@", strURL, participante.codParticipante, participante.latitudeAtual, participante.longitudeAtual, tipoParticipante, participante.latitudeFinal, participante.longitudeFinal];
        
        [self consultarUrl:url timeOut:30];
    }
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
   // NSLog(@"%@", self.dadosRetorno);
    
    [Notificacao truncateNoSave];

    NSRange strConfirmacao = [self.dadosRetorno rangeOfString:@"msg:018"];
    if (strConfirmacao.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(notificacaoesConfirmouLeitura)]) {
            [self.delegate notificacaoesConfirmouLeitura];
        }
        self.dadosRetorno = nil;
        return;
    }

    NSMutableArray *retorno = [NSMutableArray new];
    
    NSMutableArray *retornoMotoristas = [NSMutableArray new];
    NSMutableArray *retornoGrupos     = [NSMutableArray new];
    
    NSDictionary *dic = [self.dadosRetorno objectFromJSONString];
    
    NSDictionary *dicNotificacoes    = [dic objectForKey:@"notificacoes"];
    NSDictionary *dicMotoristas      = [dic objectForKey:@"motoristas"];
    NSDictionary *dicMotoristasGrupo = [dic objectForKey:@"motoristasPorGrupo"];
    NSDictionary *dicCaronas         = [dic objectForKey:@"caronas"];
    
    for (NSDictionary *dicMotoristaGrupo in dicMotoristasGrupo) {
        GrupoAtivo *grupoAtivo = [GrupoAtivo new];
        
        Grupo *grupo = [Grupo new];
        
        grupo.visivel = [NSNumber numberWithInt:[[dicMotoristaGrupo objectForKey:@"visibilidade"] intValue]];
        grupo.ativarFiltros = [NSNumber numberWithBool:[[dicMotoristaGrupo objectForKey:@"ativarFiltros"] intValue]];
        grupo.receberSolicitacao = [NSNumber numberWithBool:[[dicMotoristaGrupo objectForKey:@"solicitacaoAdesao"] intValue]];
        grupo.descricao = [NSString stringWithFormat:@"%@", [dicMotoristaGrupo objectForKey:@"descricao"]];
        grupo.nome = [NSString stringWithFormat:@"%@", [dicMotoristaGrupo objectForKey:@"nome"]];
        grupo.codGrupo = [NSString stringWithFormat:@"%@", [dicMotoristaGrupo objectForKey:@"codGrupo"]];
        
        grupoAtivo.grupo = grupo;
        
        NSDictionary *dicMotoristas = [dicMotoristaGrupo objectForKey:@"motoristas"];
        for (NSDictionary *dicMotorista in dicMotoristas) {
            MotoristaAtivo *motorista = [MotoristaAtivo new];
            motorista.descViagem   = [dicMotorista objectForKey:@"descViagem"];
            motorista.codViagem    = [dicMotorista objectForKey:@"codViagem"];
            motorista.codPessoa    = [dicMotorista objectForKey:@"codigoPessoa"];
            motorista.longitude    = [dicMotorista objectForKey:@"longitude"];
            motorista.latitude     = [dicMotorista objectForKey:@"latitude"];
            motorista.cpf          = [dicMotorista objectForKey:@"cpf"];
            motorista.quantViagens = [dicMotorista objectForKey:@"qtdViagensMotorista"];
            motorista.distMetros   = [dicMotorista objectForKey:@"distanciaParaCaronaMetros"];
            motorista.distSegundos = [dicMotorista objectForKey:@"distanciaParaCaronaSegundos"];
            motorista.nomeMotorista = [dicMotorista objectForKey:@"nome"];
            
            NSDictionary *dicVeiculos = [dicMotorista objectForKey:@"veiculo"];
            
            Veiculo *veiculo = [Veiculo new];
            
            NSString *modelo = [dicVeiculos objectForKey:@"modelo"];
            NSString *ano    = [NSString stringWithFormat:@"%@", [dicVeiculos objectForKey:@"ano"]];
            NSString *placa  = [dicVeiculos objectForKey:@"placa"];
            NSString *marca  = [dicVeiculos objectForKey:@"marca"];
            NSString *cor    = [dicVeiculos objectForKey:@"cor"];
            
            veiculo.ano = ano;
            veiculo.modelo = modelo;
            veiculo.placa = placa;
            veiculo.marca = marca;
            veiculo.cor = cor;
            
            motorista.veiculo = veiculo;
            
            Rota *rota = [Rota new];
            rota.descricao = motorista.descViagem;
            
            NSDictionary *dicRotas = [dicMotorista objectForKey:@"coordenadasRota"];
            for (NSDictionary *dicRota in dicRotas) {
                Ponto *ponto = [Ponto new];
                ponto.latitude = [[dicRota objectForKey:@"latitude"] floatValue];
                ponto.latitude = [[dicRota objectForKey:@"longitude"] floatValue];
                [rota addPontosObject:ponto];
            }
            
            motorista.rota = rota;
            
            [grupoAtivo addMotoristasAtivosObject:motorista];
            
        }
        
        [retornoGrupos addObject:grupoAtivo];
        
    }
    
    for (NSDictionary *dicMotorista in dicMotoristas) {
        MotoristaAtivo *motorista = [MotoristaAtivo new];
        motorista.descViagem   = [dicMotorista objectForKey:@"descViagem"];
        motorista.codViagem    = [dicMotorista objectForKey:@"codViagem"];
        motorista.codPessoa    = [dicMotorista objectForKey:@"codigoPessoa"];
        motorista.longitude    = [dicMotorista objectForKey:@"longitude"];
        motorista.latitude     = [dicMotorista objectForKey:@"latitude"];
        motorista.cpf          = [dicMotorista objectForKey:@"cpf"];
        motorista.quantViagens = [dicMotorista objectForKey:@"qtdViagensMotorista"];
        motorista.distMetros   = [dicMotorista objectForKey:@"distanciaParaCaronaMetros"];
        motorista.distSegundos = [dicMotorista objectForKey:@"distanciaParaCaronaSegundos"];
        motorista.nomeMotorista = [dicMotorista objectForKey:@"nome"];
        
        NSDictionary *dicVeiculos = [dicMotorista objectForKey:@"veiculo"];

        Veiculo *veiculo = [Veiculo new];
        
        NSString *modelo = [dicVeiculos objectForKey:@"modelo"];
        NSString *ano    = [NSString stringWithFormat:@"%@", [dicVeiculos objectForKey:@"ano"]];
        NSString *placa  = [dicVeiculos objectForKey:@"placa"];
        NSString *marca  = [dicVeiculos objectForKey:@"marca"];
        NSString *cor    = [dicVeiculos objectForKey:@"cor"];
        
        veiculo.ano = ano;
        veiculo.modelo = modelo;
        veiculo.placa = placa;
        veiculo.marca = marca;
        veiculo.cor = cor;
        
        motorista.veiculo = veiculo;
        
        Rota *rota = [Rota new];
        rota.descricao = motorista.descViagem;
        
        NSDictionary *dicRotas = [dicMotorista objectForKey:@"coordenadasRota"];
        for (NSDictionary *dicRota in dicRotas) {
            Ponto *ponto = [Ponto new];
            ponto.latitude = [[dicRota objectForKey:@"latitude"] floatValue];
            ponto.latitude = [[dicRota objectForKey:@"longitude"] floatValue];
            
            [rota addPontosObject:ponto];
        }
        
        motorista.rota = rota;
        
        [retornoMotoristas addObject:motorista];
    }
    
    for (NSDictionary *dicNotificacao in dicNotificacoes) {
        
        Notificacao *notificacao = [Notificacao new];
        
        NSNumber *codigo = [dicNotificacao objectForKey:@"codigo"];
        NSNumber *tipoNotificacao = [dicNotificacao objectForKey:@"tipo"];
        NSNumber *codRemetente = [dicNotificacao objectForKey:@"codRemetente"];
        NSNumber *codGrupo = [dicNotificacao objectForKey:@"codGrupo"];
        NSNumber *viagens = [dicNotificacao objectForKey:@"numViagens"];
        
        NSString *modeloVeiculo = [dicNotificacao objectForKey:@"modeloVeiculo"];
        NSString *placa = [dicNotificacao objectForKey:@"placa"];
        NSString *anoVeiculo = [dicNotificacao objectForKey:@"ano"];
        NSString *cor = [dicNotificacao objectForKey:@"cor"];
        
        NSString *nomeGrupo = [dicNotificacao objectForKey:@"nomeGrupo"];
        NSString *nomeRemetente = [dicNotificacao objectForKey:@"nomeRemetente"];
        NSString *cpfRemetente = [dicNotificacao objectForKey:@"cpfRemetente"];
        NSString *dataCadastro = [dicNotificacao objectForKey:@"dataCadastro"];
        NSString *mensagem = [dicNotificacao objectForKey:@"mensagem"];
        NSString *destinoCarona = [dicNotificacao objectForKey:@"destinoCarona"];
        
        NSString *latitude = [dicNotificacao objectForKey:@"latitude"];
        NSString *longitude = [dicNotificacao objectForKey:@"longitude"];
        
        NSDictionary *dicVeiculos = [dicNotificacao objectForKey:@"veiculos"];
        NSMutableArray *carros = [NSMutableArray new];
        for (NSDictionary *dicVeiculo in dicVeiculos) {
            Veiculo *veiculo = [Veiculo new];
            
            NSString *modelo = [dicVeiculo objectForKey:@"modelo"];
            NSString *ano    = [NSString stringWithFormat:@"%@", [dicVeiculo objectForKey:@"ano"]];
            
            veiculo.ano = ano;
            veiculo.modelo = modelo;
            
            [carros addObject:veiculo];
        }
        
        Participante *remetente = [Participante new];
        remetente.codParticipante = [NSString stringWithFormat:@"%@", codRemetente];
        remetente.nome = nomeRemetente;
        remetente.carro = [NSSet setWithArray:carros];
        remetente.cpf = cpfRemetente;
        if (latitude) {
            remetente.latitudeAtual = [NSNumber numberWithFloat:[latitude floatValue]];
            remetente.longitudeAtual = [NSNumber numberWithFloat:[longitude floatValue]];
            //NSLog(@"Notificação: latitude = %@ , longitude = %@", latitude, longitude);
        }
        
        notificacao.modeloVeiculo = modeloVeiculo;
        notificacao.placaVeiculo = placa;
        notificacao.anoVeiculo = anoVeiculo;
        notificacao.corVeiculo = cor;
        notificacao.numViagensMotorista = viagens;
        notificacao.codigo = codigo;
        notificacao.tipo = tipoNotificacao;
        notificacao.codGrupo = codGrupo;
        notificacao.nomeGrupo = nomeGrupo;
        notificacao.solicitante = remetente;
        notificacao.viagens = viagens;
        notificacao.dataCadastro = dataCadastro;
        notificacao.destinatario = [AppHelper getParticipanteLogado];
        notificacao.mensagem = mensagem;
        notificacao.nomeDestino = destinoCarona;
        notificacao.latitude = latitude;
        notificacao.longitude = longitude;

        [retorno addObject:notificacao];
        
    }
    
    NSMutableArray *caronas = [NSMutableArray new];
    
    for (NSDictionary *dicCarona in dicCaronas) {
        Ponto *ponto = [Ponto new];
        
        NSString *latitude = [dicCarona objectForKey:@"latitude"];
        NSString *longitud = [dicCarona objectForKey:@"longitude"];
        
        ponto.latitude = [latitude floatValue];
        ponto.longitude = [longitud floatValue];
        
        [caronas addObject:ponto];
    }
    
    if ([caronas count] > 0) {
        [AppHelper setCaronas:caronas];
        //NSLog(@"%@", [AppHelper getCaronas]);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(notificacaoesRecebidas:grupos:motoristas:)]) {
        [self.delegate notificacaoesRecebidas:retorno grupos:retornoGrupos motoristas:retornoMotoristas];
    }
    
   // NSLog(@"%@", retornoGrupos);
}

@end
