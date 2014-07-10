//
//  Ponto.h
//  Vamu
//
//  Created by Guilherme Augusto on 14/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "Model+JSONKit.h"

@interface Ponto : Model

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) int32_t ordem;

@end
