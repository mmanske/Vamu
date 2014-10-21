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
#import "Participante.h"
#import "Veiculo.h"
#import "RotasVO.h"
#import "MLPAutoCompleteTextField.h"
#import "PlacesService.h"
#import "DEMOCustomAutoCompleteCell.h"
#import "KSEnhancedKeyboard.h"
#import "UIViewController+AMSlideMenu.h"

@interface DefinirTrajetoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, RotaCellDelegate, UIAlertViewDelegate, MLPAutoCompleteTextFieldDelegate, MLPAutoCompleteTextFieldDataSource, PlacesServiceDelegate, UITextFieldDelegate, KSEnhancedKeyboardDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *edtOrigem;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *edtDestino;
@property (weak, nonatomic) IBOutlet UICollectionView *tabela;
@property (weak, nonatomic) IBOutlet UIImageView *imgMotorista;
@property (weak, nonatomic) IBOutlet UILabel *lblNomeMotorista;
@property (strong, nonatomic) Participante *participanteLogado;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcoIndicacao;
@property BOOL carona;
@property (strong, nonatomic) Veiculo *veiculo;
@property(nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)btnIrClick:(id)sender;
- (IBAction)btnFavoritosClick:(id)sender;


@end
