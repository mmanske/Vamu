//
//  LoginService.m
//  Vamu
//
//  Created by Guilherme Augusto on 17/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "LoginService.h"
#import "Veiculo.h"
#import "TrajetoFavorito.h"
#import "Notificacao.h"
#import "AppHelper.h"

@implementation LoginService

-(void)derrubarSessao:(NSString *)cpf{
    NSString *strURL = [self confereURLConexao:@"login/derrubarSecao"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", strURL, cpf];
    
    [self consultarUrl:url timeOut:30];
}

-(void)fazerLoginComCPF:(NSString *)cpf eSenha:(NSString *)senha{
    NSString *strURL = [self confereURLConexao:@"login/validar"];
    if (strURL == nil) {
        return;
    }
    NSString *cpfSemMascara = [AppHelper limparCPF:cpf];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", strURL, cpfSemMascara, senha];
    
    [self consultarUrl:url timeOut:60];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    NSLog(@"%@", self.dadosRetorno);

    NSRange strCpfInexistente = [self.dadosRetorno rangeOfString:@"msg:006"];
    if (strCpfInexistente.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginCPFNaoCadastrado)]) {
            [self.delegate loginCPFNaoCadastrado];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strMotoristaSemViagem = [self.dadosRetorno rangeOfString:@"msg:008"];
    if (strMotoristaSemViagem.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginMotoristaSemViagem)]) {
            [self.delegate loginMotoristaSemViagem];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strMotoristaComViagem = [self.dadosRetorno rangeOfString:@"msg:009"];
    if (strMotoristaComViagem.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginMotoristaComViagem)]) {
            [self.delegate loginMotoristaComViagem];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strCaronaSemViagem = [self.dadosRetorno rangeOfString:@"msg:0010"];
    if (strCaronaSemViagem.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginCaronSemViagem)]) {
            [self.delegate loginCaronSemViagem];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strCaronaComViagem = [self.dadosRetorno rangeOfString:@"msg:011"];
    if (strCaronaComViagem.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginCaronComViagem)]) {
            [self.delegate loginCaronComViagem];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    /*
    NSRange strContaInativa = [self.dadosRetorno rangeOfString:@"msg:012"];
    if (strContaInativa.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginContaNaoAtiva)]) {
            [self.delegate loginContaNaoAtiva];
        }
        self.dadosRetorno = nil;
        return;
    } */
    
    NSRange strSenhaInvalida = [self.dadosRetorno rangeOfString:@"msg:015"];
    if (strSenhaInvalida.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginSenhaInvalida)]) {
            [self.delegate loginSenhaInvalida];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strTresTentativas = [self.dadosRetorno rangeOfString:@"msg:016"];
    if (strTresTentativas.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginErroSenhaTerceiraTentativa)]) {
            [self.delegate loginErroSenhaTerceiraTentativa];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strFalhaSalvarAcesso = [self.dadosRetorno rangeOfString:@"Erro:101"];
    if (strFalhaSalvarAcesso.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginFalhaAoSalvarAcesso)]) {
            [self.delegate loginFalhaAoSalvarAcesso];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strErro1 = [self.dadosRetorno rangeOfString:@"error"];
    if (strErro1.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginErro:)]) {
            [self.delegate loginErro:@"Erro ao efetuar login"];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strErro = [self.dadosRetorno rangeOfString:@"Erro:113"];
    if (strErro.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginErro:)]) {
            [self.delegate loginErro:@"Erro ao efetuar login"];
        }
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strRange = [self.dadosRetorno rangeOfString:@"HTTP Status 404"];
    if (strRange.length > 0) {
        [self enviaMensagemErro:@"Erro na carga de dados"];
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange rangeErro = [self.dadosRetorno rangeOfString:@"Service Temporarily Unavailable"];
    if (rangeErro.length > 0) {
        [self enviaMensagemErro:@"Servidor indisponível"];
        self.dadosRetorno = nil;
        return;
    }
    
    NSDictionary *dic = [self.dadosRetorno objectFromJSONString];
    
    NSString *testeNome = [NSString stringWithFormat:@"%@", [dic objectForKey:@"nome"]];
    if (testeNome == NULL) {
        [self enviaMensagemErro:@"Erro ao efetuar login"];
        self.dadosRetorno = nil;
        return;
    }
    
    [Participante truncateNoSave];
    [Veiculo truncateNoSave];
    [TrajetoFavorito truncateNoSave];
    [Notificacao truncateNoSave];
    
    Participante *participanteLogado = [Participante new];
    
    
    NSString *apelido = [dic objectForKey:@"apelido"];
    NSString *bairro  = [dic objectForKey:@"bairro"];
    NSString *celular = [dic objectForKey:@"celular"];
    NSString *cep     = [dic objectForKey:@"cep"];
    NSString *cidade  = [dic objectForKey:@"cidade"];
    NSNumber *codPart = [dic objectForKey:@"codigoPessoa"];
    NSString *complem = [dic objectForKey:@"complemento"];
    NSString *cpf     = [dic objectForKey:@"cpf"];
    NSString *email   = [dic objectForKey:@"email"];
    NSString *endere  = [dic objectForKey:@"endereco"];
    NSString *fixo    = [dic objectForKey:@"fixo"];
    NSString *nasci   = [dic objectForKey:@"nascimento"];
    NSString *nome    = [dic objectForKey:@"nome"];
    NSString *numero  = [dic objectForKey:@"numero"];
    NSString *senha   = [dic objectForKey:@"senha"];
    NSNumber *sexo    = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"sexo"]] isEqualToString:@"M"] ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
    NSString *uf      = [dic objectForKey:@"uf"];
    NSNumber *vjCarona = [dic objectForKey:@"viajensCarona"];
    NSNumber *vjMotori = [dic objectForKey:@"viajensMotorista"];
    
    participanteLogado.codParticipante = [NSString stringWithFormat:@"%@", codPart];
    participanteLogado.apelido         = apelido;
    participanteLogado.bairro          = bairro;
    participanteLogado.celular         = celular;
    participanteLogado.cep             = cep;
    participanteLogado.cidade          = cidade;
    participanteLogado.complemento     = complem;
    participanteLogado.cpf             = cpf;
    participanteLogado.email           = email;
    participanteLogado.endereco        = endere;
    participanteLogado.fixo            = fixo;
    participanteLogado.nascimento      = nasci;
    participanteLogado.nome            = nome;
    participanteLogado.numero          = numero;
    participanteLogado.senha           = senha;
    participanteLogado.sexo            = sexo;
    participanteLogado.uf              = uf;
    participanteLogado.viajensMotorista = vjMotori;
    participanteLogado.viajensCarona = vjCarona;
    
    BOOL isAtivo = NO;
    
    NSDictionary *dicCarros = [dic objectForKey:@"veiculos"];
    for (NSDictionary *dicCarro in dicCarros) {
        
        
        NSNumber *ano     = [dicCarro objectForKey:@"ano"];
        NSString *cor     = [dicCarro objectForKey:@"cor"];
        NSNumber *idBanco = [NSNumber numberWithInteger:[[dicCarro objectForKey:@"idBanco"] integerValue]];
        NSString *marca   = [dicCarro objectForKey:@"marca"];
        NSString *modelo  = [dicCarro objectForKey:@"modelo"];
        NSString *placa   = [dicCarro objectForKey:@"placa"];
        NSString *renavam = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:[[dicCarro objectForKey:@"renavam"] intValue]]];
        NSString *segura  = [dicCarro objectForKey:@"seguradora"];
        
        Veiculo *veiculo   = [Veiculo new];
        veiculo.ano        = [NSString stringWithFormat:@"%@", ano];
        veiculo.cor        = cor;
        veiculo.idBanco    = idBanco;
        veiculo.marca      = marca;
        veiculo.modelo     = modelo;
        veiculo.placa      = placa;
        veiculo.renavan    = renavam;
        veiculo.seguradora = segura;
        
        veiculo.participante = participanteLogado;
        [participanteLogado addCarroObject:veiculo];
        isAtivo = YES;
        
    }
    
    NSDictionary *dicTrajetos = [dic objectForKey:@"trajetosFavoritos"];
    for (NSDictionary *dicTrajeto in dicTrajetos) {

        float latitude = [[dicTrajeto objectForKey:@"latitudeDestino"] floatValue];
        float longitude = [[dicTrajeto objectForKey:@"longitudeDestino"] floatValue];
        NSString *desc = [dicTrajeto objectForKey:@"descricao"];
        NSNumber *cod = [dicTrajeto objectForKey:@"codigo"];
        
        TrajetoFavorito *trajeto = [TrajetoFavorito new];
        trajeto.descricao = desc;
        trajeto.latitude = latitude;
        trajeto.longitude = longitude;
        trajeto.codigo = cod;
        
        trajeto.participante = participanteLogado;
        [participanteLogado addTrajetosFavoritosObject:trajeto];
    }
    
    [Model saveAll:nil];
    
    if (isAtivo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginOk:)]) {
            [self.delegate loginOk:participanteLogado];
        }
        
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginContaNaoAtiva:)]) {
            [self.delegate loginContaNaoAtiva: participanteLogado];
        }

    }
    
}

-(void) enviaMensagemErro:(NSString*) msgErro {
    self.dadosRetorno = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginErro:)]) {
        [self.delegate loginErro:msgErro];
    }
}

-(void)onOcorreuTimeout:(NSString *)msg{
    self.dadosRetorno = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginErro:)]) {
        [self.delegate loginErro:@"Tempo esgotado"];
    }
}


@end
