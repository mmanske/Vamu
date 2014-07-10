//
//  RotasVO.h
//  Vamu
//
//  Created by Guilherme Augusto on 14/06/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TrajetoFavorito.h"

@interface RotasVO : NSObject

@property (strong, nonatomic) MKRoute *rota;
@property (strong, nonatomic) TrajetoFavorito *trajetoFavorito;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
