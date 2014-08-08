//
//  LogoutService.m
//  Vamu
//
//  Created by Márcio S. Manske on 08/08/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "LogoutService.h"

@implementation LogoutService

-(void) logout:(NSString*) cpf {
    NSString *strURL = [self confereURLConexao:@"login/logout"];
    if (strURL == nil) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", strURL, cpf];
    
    [self consultarUrl:url timeOut:30];
    
}

-(void) trataRecebimento{
    [super trataRecebimento];
}
@end
