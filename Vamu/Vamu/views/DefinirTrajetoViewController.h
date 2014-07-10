//
//  DefinirTrajetoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 25/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "DefinirTrajetoCell.h"
#import "RotaCell.h"
#import "BaseViewController.h"
#import "Participante.h"
#import "Veiculo.h"
#import "RotasVO.h"
#import "MLPAutoCompleteTextField.h"
#import "PlacesService.h"
#import "DEMOCustomAutoCompleteCell.h"

@interface DefinirTrajetoViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, RotaCellDelegate, UIAlertViewDelegate, MLPAutoCompleteTextFieldDelegate, MLPAutoCompleteTextFieldDataSource, PlacesServiceDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *edtOrigem;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *edtDestino;
@property (weak, nonatomic) IBOutlet UICollectionView *tabela;
@property (weak, nonatomic) IBOutlet UIImageView *imgMotorista;
@property (weak, nonatomic) IBOutlet UILabel *lblNomeMotorista;
@property (strong, nonatomic) IBOutlet UILabel *lblTipo;
@property (strong, nonatomic) Participante *participanteLogado;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcoIndicacao;
@property BOOL carona;
@property (strong, nonatomic) Veiculo *veiculo;

- (IBAction)btnIrClick:(id)sender;
- (IBAction)btnFavoritosClick:(id)sender;


@end
