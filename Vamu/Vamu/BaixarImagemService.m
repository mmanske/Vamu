//
//  BaixarImagem.m
//  Vamu
//
//  Created by Márcio S. Manske on 03/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaixarImagemService.h"
#import "AppHelper.h"

@interface BaixarImagemService()


@property (nonatomic) NSString* nomeArquivo;

@end


@implementation BaixarImagemService


-(void) baixarImagemDePessoa:(NSString*) cpf {
    
    NSString *strURL = [DadosConexaoService getURLConexaoForImages];
    if (strURL == nil) {
        return;
    }
    NSString *nomeArquivo = [NSString stringWithFormat:@"%@.jpg", cpf];
    
    
    NSString* absoluteFileName = [AppHelper getAbsolutePathForImageFile:nomeArquivo];
    
    self.nomeArquivo = absoluteFileName;
    NSFileManager *manager = [NSFileManager defaultManager];
    

    
    BOOL arquivoExiste = [manager fileExistsAtPath:absoluteFileName];
    NSString *fileDate = @"";
    long long tamanho = 0;
    if (arquivoExiste) {
        
        NSDictionary *attrs = [manager attributesOfItemAtPath: absoluteFileName error: NULL];
        tamanho = [attrs fileSize];
        NSDate *modDate = [attrs fileModificationDate];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        fileDate = [dateFormatter stringFromDate:modDate];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@?fileName=%@&fileDate=%@&fileSize=%lli", strURL, nomeArquivo, fileDate, tamanho];
    
    [self consultarUrl:url timeOut:30];
    
}

-(void) baixarImagemDeCarro:(NSString*) cpf placa:(NSString*) placa {
    NSString *nomeArquivo = [NSString stringWithFormat:@"%@-%@", cpf, placa];
    [self baixarImagemDePessoa:nomeArquivo];
}

-(void)trataRecebimento{
    NSFileManager *manager = [NSFileManager defaultManager];

    NSRange arquivoNaoExiste = [self.dadosRetorno rangeOfString:@"NOT_EXISTS"];
    if (arquivoNaoExiste.length > 0) {
        self.dadosRetorno = nil;
        //remove o arquivo pois o mesmo não existe no servidor
        
        if ([manager fileExistsAtPath:self.nomeArquivo]) {
            [manager removeItemAtPath:self.nomeArquivo error:NULL];
        }
        
    } else {
        NSRange arquivoJaAtualizado = [self.dadosRetorno rangeOfString:@"NOT_NEEDED"];
        if (arquivoJaAtualizado.length == 0) {
            //Precisa gravar o arquivo
            [self.dataRetorno writeToFile:self.nomeArquivo atomically:YES];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(finalizaBaixarImagem)]) {
        [self.delegate finalizaBaixarImagem];
    }

}

@end
