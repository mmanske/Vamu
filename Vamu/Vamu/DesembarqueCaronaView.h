//
//  DesembarqueCaronaView.h
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participante.h"
#import "CaronaService.h"

@protocol DesembarqueCaronaViewDelegate <NSObject>

-(void) desembarquei;

@end

@interface DesembarqueCaronaView : UIView{
    id <DesembarqueCaronaViewDelegate> delegate;
}

@property (strong, nonatomic) CaronaService *caronaService;
@property (strong, nonatomic) Participante *carona;
@property (weak, nonatomic) IBOutlet UILabel *lblKM;
@property (weak, nonatomic) IBOutlet UIButton *btnDesembarquei;
@property (nonatomic) id delegate;

- (IBAction)btnDesembarqueiClick:(id)sender;
-(id) iniciar;

@end
