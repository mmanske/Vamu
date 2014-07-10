//
//  CustomActivityView.m
//  ComandaiOS
//
//  Created by Marcio Manske on 14/05/12.
//  Copyright (c) 2012 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import "CustomActivityView.h"
#import "CustomAlertView.h"

@interface CustomActivityView()

@property (nonatomic, strong) CustomAlertView *alert;

@end

@implementation CustomActivityView
@synthesize alert;

-(id) init {
    self = [super init];
    if (self) {
        self.alert = [CustomAlertView new];
        UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 80, 30, 30)];
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [alert addSubview:progress];
        [progress startAnimating];
    }
    return self;
}

-(void) exibir: (NSString*) mensagem {
    
    alert.message = mensagem;
    if (!alert.visible) {
        [alert show];    
    }
     
    
}

-(void) exibir {
    [self exibir: @"Aguarde, conectando com o servidor..."];
}

-(void) exibirGravacaoDados {
    [self exibir: @"Gravando os dados localmente..."];
}

-(void) esconder {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


@end
