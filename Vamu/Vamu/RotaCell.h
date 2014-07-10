//
//  RotaCell.h
//  Vamu
//
//  Created by Guilherme Augusto on 09/04/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Participante.h"
#import "RotasVO.h"

@protocol RotaCellDelegate

-(void) iniciarRota:(MKRoute*) rota;
-(void) salvarRotaFavorita:(MKRoute*) rota;
-(void) removerRotaFavorita:(RotasVO*) rota;

@end

@interface RotaCell : UICollectionViewCell<MKMapViewDelegate, UIGestureRecognizerDelegate>{
    id <RotaCellDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UIButton *btnEstrela;
@property (strong, nonatomic) RotasVO *rotaVO;
@property (nonatomic) id delegate;
@property BOOL favorita;

- (IBAction)btnIniciarNagevacaoClick:(id)sender;
-(RotaCell*) initWithRoute:(MKRoute*)route indexPath:(NSIndexPath*) indexPath delegate:(id<RotaCellDelegate>) viewDelegate favorito:(BOOL) favorito ;

-(RotaCell*) initWithRotaVO:(RotasVO*) rota indexPath:(NSIndexPath*) indexPath delegate:(id<RotaCellDelegate>) viewDelegate;

- (IBAction)btnEstrelaClick:(id)sender;

@end
