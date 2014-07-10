//
//  DefinirTrajetoCell.h
//  Vamu
//
//  Created by Guilherme Augusto on 25/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol DefinirTrajetoCellDelegate <NSObject>

-(void) selecionouTrajeto;

@end

@interface DefinirTrajetoCell : UICollectionViewCell{
    id <DefinirTrajetoCellDelegate> delegate;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTempo;
@property (weak, nonatomic) IBOutlet UILabel *lblDistancia;
@property (weak, nonatomic) IBOutlet UILabel *lblObs;
@property (weak, nonatomic) IBOutlet UIButton *btnDefinirTrajeto;
@property (nonatomic) id delegate;
@property (nonatomic) int indexArray;

- (IBAction)btnDefinirTrajetoClick:(id)sender;

-(DefinirTrajetoCell*) iniciarComRota:(MKRoute*) rota delegate:(id) dele index:(int) index;

@end
