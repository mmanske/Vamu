//
//  Model+JSONKit.h
//  ExemploOrigemReserva
//
//  Created by Marcio Manske on 21/07/11.
//  Copyright 2011 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Model (Model_JSONKit)

+(id)objectFromDictionary: (NSDictionary*) dic;
-(NSDictionary*)dictionaryFromObject;

@end
