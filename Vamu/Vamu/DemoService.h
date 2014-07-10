//
//  DemoHelper.h
//  VisitaMobile
//
//  Created by Marcio Manske on 04/10/11.
//  Copyright 2011 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DemoService : NSObject

@property (nonatomic, unsafe_unretained) id delegate;
-(void) criarDadosDemonstracao;

@end

@interface NSObject (DemoServiceDelegate)

-(void)onDemoSucesso;
-(void)onDemoErro:(NSString*) msgErro;

@end