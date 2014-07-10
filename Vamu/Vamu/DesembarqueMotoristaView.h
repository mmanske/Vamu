//
//  DesembarqueMotoristaView.h
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participante.h"

@protocol DesembarqueMotoristaViewDelegate <NSObject>

-(void) desembarcou:(Participante*) participante;
-(void) embarcou:(Participante*) participante;
-(void) cancelouEmbarque:(Participante*) participante;

@end

@interface DesembarqueMotoristaView : UIView{
    id <DesembarqueMotoristaViewDelegate> delegate;
}

@property (nonatomic) id delegate;

-(id) iniciarComParticipante:(Participante*) participante;

@property (weak, nonatomic) IBOutlet UIImageView *imgCarona;
@property (weak, nonatomic) IBOutlet UILabel *lblNomeCarona;
@property (weak, nonatomic) IBOutlet UILabel *lblDestinoCarona;
@property (weak, nonatomic) IBOutlet UIButton *btnDesembarcou;
@property (strong, nonatomic) Participante *carona;
@property (strong, nonatomic) IBOutlet UIButton *btnEmbarcou;
@property (strong, nonatomic) IBOutlet UIButton *btnCancelou;

- (IBAction)btnDesembarcouClick:(id)sender;
- (IBAction)btnEmbarcouClick:(id)sender;
- (IBAction)btnCancelouEmbarqueClick:(id)sender;


@end
