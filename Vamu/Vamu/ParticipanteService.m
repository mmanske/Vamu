//
//  ParticipanteService.m
//  Vamu
//
//  Created by Guilherme Augusto on 07/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

//private String cpf;
//private String senha;
//private String nome;
//private String apelido;
//private String email;
//private String sexo;
//private String foto;
//private Date dataNascimento;
//private String endereco;
//private String bairro;
//private String cidade;
//private String uf;
//private String complemento;
//private String numero;
//private String cep;
//private String telefone1;

#import "ParticipanteService.h"
#import "AppHelper.h"

@implementation ParticipanteService

-(NSMutableDictionary*) dicionarioParticipante:(Participante*) participante{
    NSMutableDictionary *dicParticipante = [NSMutableDictionary new];
    
    
    [dicParticipante setObject:[AppHelper limparCPF:participante.cpf] forKey:@"cpf"];
    [dicParticipante setObject:participante.senha forKey:@"senha"];
    [dicParticipante setObject:participante.nome forKey:@"nome"];
    [dicParticipante setObject:participante.apelido forKey:@"apelido"];
    [dicParticipante setObject:participante.email forKey:@"email"];
    if ([participante.sexo isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [dicParticipante setObject:@"M" forKey:@"sexo"];
    } else {
        [dicParticipante setObject:@"F" forKey:@"sexo"];
    }
    

//    [dicParticipante setObject:[participante.foto base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed] forKey:@"foto"];
    [dicParticipante setObject:participante.nascimento forKey:@"dataNascimento"];
    [dicParticipante setObject:participante.endereco forKey:@"endereco"];
    [dicParticipante setObject:participante.bairro forKey:@"bairro"];
    [dicParticipante setObject:participante.cidade forKey:@"cidade"];
    [dicParticipante setObject:participante.uf forKey:@"uf"];
    [dicParticipante setObject:participante.complemento forKey:@"complemento"];
    [dicParticipante setObject:participante.numero forKey:@"numero"];
    [dicParticipante setObject:participante.cep forKey:@"cep"];
    [dicParticipante setObject:participante.celular forKey:@"telefone1"];
    [dicParticipante setObject:participante.codParticipante forKey:@"codigoPessoa"];
    
    return dicParticipante;
}

-(void)cadastrarParticipante:(Participante *)participante{
    NSString *strURL = [self confereURLConexao:@"usuario/novo"];
    if (strURL == nil) {
        return;
    }
    
    NSString *participanteJson = [[self dicionarioParticipante:participante] JSONString];
    
    [self lancarPost:strURL withPostString:participanteJson withTimeOut:30];
}

-(void)alterarParticipante:(Participante *)participante{
    NSString *strURL = [self confereURLConexao:@"usuario/alterar"];
    if (strURL == nil) {
        return;
    }
    
    NSString *participanteJson = [[self dicionarioParticipante:participante] JSONString];
    
    [self lancarPost:strURL withPostString:participanteJson withTimeOut:30];
}

-(void)trataRecebimento{
    [super trataRecebimento];
    
    NSRange strRange = [self.dadosRetorno rangeOfString:@"HTTP Status 404"];
    if (strRange.length > 0) {
        [self enviaMensagemErro:@"Erro na carga de dados"];
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange rangeErro = [self.dadosRetorno rangeOfString:@"Erro"];
    if (rangeErro.length > 0) {
        [self enviaMensagemErro:self.dadosRetorno];
        self.dadosRetorno = nil;
        return;
    }
    
    NSRange strRangeMsg1 = [self.dadosRetorno rangeOfString:@"falha:500"];
    if (strRangeMsg1.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(participanteNaoValidouCPF:)]) {
            [self.delegate participanteNaoValidouCPF:@"CPF já cadastrado"];
        }
        return;
    }
    
    NSRange strRangeMsg2 = [self.dadosRetorno rangeOfString:@"falha:501"];
    if (strRangeMsg2.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(participanteNaoValidouEmail:)]) {
            [self.delegate participanteNaoValidouEmail:@"E-mail já cadastrado"];
        }
        return;
    }
    
    NSRange strRangeMsg3 = [self.dadosRetorno rangeOfString:@"falha:502"];
    if (strRangeMsg3.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(participanteNaoValidouApelido:)]) {
            [self.delegate participanteNaoValidouApelido:@"Apelido já cadastrado"];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(participanteCadastradoComSucesso:)]) {
        [self.delegate participanteCadastradoComSucesso:self.dadosRetorno];
    }
    
    self.dadosRetorno = nil;
    
}

-(void) enviaMensagemErro:(NSString*) msgErro {
    self.dadosRetorno = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(participanteEnviaMensagemErro:)]) {
        [self.delegate participanteEnviaMensagemErro:msgErro];
    }
}

-(void)onOcorreuTimeout:(NSString *)msg{
    self.dadosRetorno = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(participanteEnviaMensagemErro:)]) {
        [self.delegate participanteEnviaMensagemErro:@"Tempo esgotado"];
    }
}

@end
