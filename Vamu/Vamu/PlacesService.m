//
//  PlacesService.m
//  Vamu
//
//  Created by Guilherme Augusto on 09/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "PlacesService.h"
#import "JSONObjects.h"

@implementation PlacesService

-(void)consultar:(NSString *)lugares{
    NSString *req = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=pt_BR&key=%@", [lugares stringByReplacingOccurrencesOfString:@" " withString:@"%20"], @"AIzaSyAlPms0IbqpUQg_sXJTAqLmHKCDKm_wzfQ"];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSMutableArray *retorno = [NSMutableArray new];
        NSDictionary *dic = [result objectFromJSONString];
        NSDictionary *dicPredictions = [dic objectForKey:@"predictions"];
        
        for (NSDictionary *dicPrediction in dicPredictions) {
            NSString *descricao = [dicPrediction objectForKey:@"description"];
            [retorno addObject:descricao];
        }
        
        if ([retorno count] > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(placesFound:)]) {
                [self.delegate placesFound:retorno];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(noPlacesFound)]) {
                [self.delegate noPlacesFound];
            }
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(noPlacesFound)]) {
            [self.delegate noPlacesFound];
        }
    }
}

@end
