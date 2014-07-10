//
//  BaseService.m
//  ControleVisitas
//
//  Created by Marcio Manske on 01/08/11.
//  Copyright 2011 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import "BaseService.h"
#import "AppHelper.h"

@implementation BaseService                                                                                                                                                                                                            

@synthesize dadosRetorno, delegate, timeOutTimer, conexao, deuTimeOut, dataRetorno;

- (void)timerFireMethod:(NSTimer*)theTime {
    [self onTimeOutConnection];
    [conexao cancel];
    self.conexao = nil;
}

-(id) init {
    self = [super init];
    if (self) {
        self.dadosRetorno = nil;
        self.conexao = nil;
        self.dataRetorno = nil;
        return self;
    }
    return nil;
}

-(NSString*) confereURLConexao: (NSString*) contexto {
    NSString *strURL = [DadosConexaoService getURLConexaoForServico:contexto];
    
    if (strURL == nil) {
        [self enviaMensagemErro:@"Informe o Servidor nos Ajustes"];
    }
    return strURL;
}


-(void)lancarPost:(NSString*) strUrl withFileName:(NSString*)fileName withData:(NSData*) dataToSend  withTimeOut:(int)timeOut {
   
    NSString *strUrlPost = [NSString stringWithFormat:@"%@",strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:120];
    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"userfile", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:dataToSend];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:[NSURL URLWithString:strUrlPost]];
    
    [self conecta:request timeOut:timeOut];
    
   // NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"returnString =%@",returnString);
    

}


-(void)lancarPost:(NSString *)strUrl withPostString:(NSString *)postString withTimeOut:(int)timeOut{
    self.deuTimeOut = NO;
    
    NSString *strUrlPost = [NSString stringWithFormat:@"%@",strUrl];
    NSURL *url = [NSURL URLWithString:strUrlPost];
    
//    NSData *dataRequest = [NSData dataWithBytes:[postString UTF8String] length:[postString length]];
    NSData *dataRequest = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:dataRequest];
    
    [self conecta:request timeOut:timeOut];
}

-(void)consultarUrl:(NSString *)strUrl timeOut:(int)timeOut{
    self.deuTimeOut = NO;
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    
    [self conecta:request timeOut:timeOut];
}

-(void) fazConsulta: (NSString*) codigo sUrl:(NSString*)sUrl timeOut:(int)timeOut{
    self.deuTimeOut = NO;
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@", sUrl, [codigo stringByReplacingOccurrencesOfString:@" " withString:@"#32"]];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    
    [self conecta:request timeOut:timeOut];
}

-(void) testarServidor:(NSString *)sUrl timeOut:(int)timeOut{
    self.deuTimeOut = NO;
    NSString *strUrl = [NSString stringWithFormat:@"%@", sUrl];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    
    [self conecta:request timeOut:timeOut];
}

-(void)onTimeOutConnection {
    self.deuTimeOut = YES;
    if (delegate && [delegate respondsToSelector:@selector(onOcorreuTimeout:)]) {
        [delegate onOcorreuTimeout:@"Timeout na conexão!"];
    }
}

-(void)trataRecebimento {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRecebeuDados)]) {
        [self.delegate onRecebeuDados];
    }
}

-(void) enviaMensagemErro:(NSString*) msgErro {
    
}

-(void) conecta: (NSMutableURLRequest*) request timeOut:(int) timeOut{
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    self.conexao = conn;
    self.dadosRetorno = nil;
    self.dataRetorno = nil;
    self.dataRetorno = [NSMutableData new];
    
    self.timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:timeOut target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:NO];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [dataRetorno appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [timeOutTimer invalidate];
    self.timeOutTimer = nil;
    if (!deuTimeOut) {
        if (dataRetorno) {
            NSString *aStr = [[NSString alloc] initWithData:dataRetorno encoding:NSUTF8StringEncoding];
            self.dadosRetorno = aStr;
        }
        [self trataRecebimento];
    }
    
    self.conexao = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [timeOutTimer invalidate];
    self.timeOutTimer = nil;
    if (!deuTimeOut) {
        NSString *msgError = [NSString stringWithFormat: @"%@", error.localizedDescription];
        [self enviaMensagemErro:msgError];
    }
    self.conexao = nil;
}


@end
